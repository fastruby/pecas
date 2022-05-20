require 'rails_helper'

describe Entry do
  describe "#delete_past_entries" do
    it "deletes entries older than the given date" do
      Entry.delete_all

      old_entry = create :entry, date: 11.months.ago
      new_entry = create :entry, date: 3.months.ago

      expect do
        Entry.delete_older_than(5.months.ago)
      end.to change(Entry, :count).from(2).to(1)

      expect(Entry.exists?(new_entry.id)).to be_truthy
      expect(Entry.exists?(old_entry.id)).to be_falsey
    end
  end
end