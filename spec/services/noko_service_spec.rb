require "rails_helper"

describe NokoService, :vcr do
  describe "#import_entries" do
    let(:start_date) { Time.now.beginning_of_week.to_date }
    let(:end_date) { Time.now.end_of_week.to_date }

    context "without any new entries" do
      before do
        allow(described_class.client).to receive(:get_entries).and_return([])
      end

      it "doesn't create any entries in the database" do
        expect do
          described_class.import_entries(start_date, end_date)
        end.to change(Entry, :count).by(0)
      end
    end

    context "with new entries" do
      let(:noko_user) { double("Noko::User", id: 1, state: "active") }
      let(:noko_project) { double("Noko::Project", id: 1, enabled: true) }
      let(:noko_entry) do
        double("Noko::Entry", id: 1, description: "Hello!", minutes: 60,
                                 date: Time.zone.now, user: noko_user,
                                 project: noko_project)
      end

      it "creates the new entries in the database" do
        expect do
          described_class.import_entries(start_date, end_date)
        end.to change(Entry, :count).by(2)

        entry = Entry.last
        expect(entry.description).to eql("Hello!")
        expect(entry.minutes).to eql(60)
      end

      it "doesn't create entries again if they already exist" do
        expect do
          described_class.import_entries(start_date, end_date)
        end.to change(Entry, :count).by(2)

        expect do
          described_class.import_entries(start_date, end_date)
        end.to change(Entry, :count).by(0)
      end

      context "with more than one page" do
        let(:noko_entry_2) do
          double("Noko::Entry", id: 2, description: "Quack!", minutes: 120,
                                   date: Time.zone.now, user: noko_user,
                                   project: noko_project)
        end
        let(:noko_links) { double("Noko::Record", last: "/v2/page=2") }
        let(:noko_result) do
          double("Noko::Record", link: noko_links)
        end

        it "saves all entries in every page" do
          expect do
            described_class.import_entries(start_date, end_date)
          end.to change(Entry, :count).by(2)
        end
      end

      context "when importing entries" do
        let(:start_date) { Time.now.beginning_of_week.to_date - 1.week }

        it "saves entries from the past two weeks" do
          expect do
            described_class.import_entries(start_date, end_date)
          end.to change(Entry, :count).by(3)
        end
      end

      context "when sending a missing hours reminder notification" do
        let(:user) { create(:user, name: 'Foo', email: 'bar@example.com', missing_hours_notification_enabled: true, slack_id: "78FFXDFS") }
        let(:message) { "Hello <@#{user.slack_id}>!\nIt's #{Date.today.strftime("%A")}! By now, you should have logged a total of 24 hours to be on track for a regular 40-hour week.        \n\n*So far, you have logged 22:17 hours.*\n\nCheers!" }
        let!(:entry) { create(:entry, minutes: 1337, user_id: user.id) }

        it "sends a slack message to the user" do
          expect(SlackService).to receive(:send_message).with(user.slack_id, message, Slack::Web::Client)
          described_class.send_missing_hours_reminder
        end
      end
    end
  end
end
