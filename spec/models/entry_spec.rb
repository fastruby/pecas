require 'rails_helper'

describe Entry do

  describe "delegates" do
    it "email property to user" do
      email = "steve@ombulabs.com"
      user = User.new(email: email)
      entry = Entry.new(user: user)
      expect(entry.user_email).to eql(email)
    end
  end

  describe ".for_users" do
    let!(:user_include)   { create(:user, email: 'included@example.com') }
    let!(:user_not)   { create(:user, email: 'not@example.com') }
    let!(:entry_include)   { create(:entry, user: user_include) }
    let!(:entry_not)   { create(:entry, user: user_not) }

    it 'scopes a query to users with given emails' do
      entries = Entry.for_users_by_email([user_include.email]).all
      expect(entries.count).to eql(1)
      expect(entries.first.id).to eql(entry_include.id)
      expect(entries.first.user_email).to eql(user_include.email)
    end
  end

  describe "#length" do
    it "Returns hours label for full hours" do
      entry = Entry.new(minutes: 60)
      expect(entry.length).to eql("1 hour")

      entry = Entry.new(minutes: 120)
      expect(entry.length).to eql("2 hours")
    end

    it "Returns minutes label for partial hours" do
      entry = Entry.new(minutes: 1)
      expect(entry.length).to eql("1 minute")

      entry = Entry.new(minutes: 2)
      expect(entry.length).to eql("2 minutes")
    end

    it "Returns hours with minutes if required" do
      entry = Entry.new(minutes: 90)
      expect(entry.length).to eql("1 hour, 30 minutes")
    end
  end

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