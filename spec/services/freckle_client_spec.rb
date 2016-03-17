require "rails_helper"

describe FreckleService do
  subject { described_class.new }
  before do
    stub_const("ENV", {"FRECKLE_TOKEN" => "foobar"})
  end

  describe "#import_entries" do
    let(:start_date) { Time.now.beginning_of_week.to_date }
    let(:end_date) { Time.now.end_of_week.to_date }

    context "without any new entries" do
      before do
        allow(subject.client).to receive(:get_entries).and_return([])
      end

      it "doesn't create any entries in the database" do
        expect do
          subject.import_entries(start_date, end_date)
        end.to change(Entry, :count).by(0)
      end
    end

    context "with new entries" do
      let(:freckle_user) { double("Freckle::User", id: 1) }
      let(:freckle_project) { double("Freckle::Project", id: 1) }
      let(:freckle_entry) do
        double("Freckle::Entry", id: 1, description: "Hello!", minutes: 60,
                                 date: Time.zone.now, user: freckle_user,
                                 project: freckle_project)
      end

      before do
        allow(subject.client).to(
          receive(:get_entries).and_return([freckle_entry]))
      end

      it "creates the new entries in the database" do
        expect do
          subject.import_entries(start_date, end_date)
        end.to change(Entry, :count).by(1)

        entry = Entry.last
        expect(entry.description).to eql("Hello!")
        expect(entry.minutes).to eql(60)
      end

      it "doesn't create entries again if they already exist" do
        expect do
          subject.import_entries(start_date, end_date)
        end.to change(Entry, :count).by(1)

        expect do
          subject.import_entries(start_date, end_date)
        end.to change(Entry, :count).by(0)
      end
    end
  end
end
