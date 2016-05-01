require "rails_helper"

describe FreckleService do
  before do
    stub_const("ENV", {"FRECKLE_TOKEN" => "foobar"})
  end

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
      let(:freckle_user) { double("Freckle::User", id: 1, state: "active") }
      let(:freckle_project) { double("Freckle::Project", id: 1, enabled: true) }
      let(:freckle_entry) do
        double("Freckle::Entry", id: 1, description: "Hello!", minutes: 60,
                                 date: Time.zone.now, user: freckle_user,
                                 project: freckle_project)
      end

      before do
        allow(described_class.client).to(
          receive(:get_entries).and_return([freckle_entry]))
      end

      it "creates the new entries in the database" do
        expect do
          described_class.import_entries(start_date, end_date)
        end.to change(Entry, :count).by(1)

        entry = Entry.last
        expect(entry.description).to eql("Hello!")
        expect(entry.minutes).to eql(60)
      end

      it "doesn't create entries again if they already exist" do
        expect do
          described_class.import_entries(start_date, end_date)
        end.to change(Entry, :count).by(1)

        expect do
          described_class.import_entries(start_date, end_date)
        end.to change(Entry, :count).by(0)
      end

      context "with more than one page" do
        let(:freckle_entry_2) do
          double("Freckle::Entry", id: 2, description: "Quack!", minutes: 120,
                                   date: Time.zone.now, user: freckle_user,
                                   project: freckle_project)
        end
        let(:freckle_links) { double("Freckle::Record", last: "/v2/page=2") }
        let(:freckle_result) do
          double("Freckle::Record", link: freckle_links)
        end

        before do
          allow(freckle_result).to(
            receive(:each).and_yield(freckle_entry).and_yield(freckle_entry_2))

          allow(described_class.client).to(
            receive(:get_entries).and_return(freckle_result).twice)
        end

        it "saves all entries in every page" do
          expect do
            described_class.import_entries(start_date, end_date)
          end.to change(Entry, :count).by(2)
        end
      end
    end
  end
end
