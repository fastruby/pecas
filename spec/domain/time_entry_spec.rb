require "rails_helper"

describe TimeEntry do
  let!(:user_1) { create(:user, email: "steve@ombulabs.com") }
  let!(:user_2) { create(:user, email: "carole@ombulabs.com") }
  let!(:entry_1)   { create(:entry, user: user_1, date: Date.new(2022, 3, 1), description: "A non-descriptive description 1", minutes: 120) }
  let!(:entry_2)   { create(:entry, user: user_1, date: Date.new(2022, 3, 1), description: "A non-descriptive description 2", minutes: 90) }
  let!(:entry_3)   { create(:entry, user: user_1, date: Date.new(2022, 3, 1), description: "A non-descriptive description 3", minutes: 20) }
  let!(:entry_4)   { create(:entry, user: user_1, date: Date.new(2022, 3, 2), description: "A non-descriptive description 3", minutes: 10) }
  let!(:other_user_entry)   { create(:entry, date: Date.new(2022, 3, 1)) }

  describe "#invalid_time_entries_alert" do
    let(:time_entry) {
      TimeEntry.new(Date.new(2022, 3, 1), TimeEntrySpec::GroupMemberMessagingMock, TimeEntry::DescriptionRules, hour_of_day: 20)
    }

    it "sets a messaging service with expected options" do
      allow(TimeEntrySpec::GroupMemberMessagingMock).to receive(:new).and_return(TimeEntrySpec::GroupMemberMessagingMock.new(nil, nil).set_mock(user_1, user_2))
      allow_any_instance_of(TimeEntry::DescriptionRules).to receive(:valid?).and_return(true)
      expect(TimeEntrySpec::GroupMemberMessagingMock).to receive(:new).with("ombuteam", hour_to_run: 20)
      time_entry.invalid_time_entries_alert("ombuteam")
    end

    it "queries for entries related to emails found in the messaging service" do
      allow(TimeEntrySpec::GroupMemberMessagingMock).to receive(:new).and_return(TimeEntrySpec::GroupMemberMessagingMock.new(nil, nil).set_mock(user_1, user_2))
      allow_any_instance_of(TimeEntry::DescriptionRules).to receive(:valid?).and_return(true)
      time_entry.invalid_time_entries_alert("ombuteam")
      expect(time_entry.grouped_entries.keys).to eql(["steve@ombulabs.com"])
      expect(time_entry.grouped_entries["steve@ombulabs.com"].count).to eql(3)
      expect(time_entry.grouped_entries["steve@ombulabs.com"]).to include(entry_1)
      expect(time_entry.grouped_entries["steve@ombulabs.com"]).to include(entry_2)
      expect(time_entry.grouped_entries["steve@ombulabs.com"]).to include(entry_3)
    end

    it "calls send_time_entry_format_warning on the service if there are invalid entries" do
      mock_service_instance = TimeEntrySpec::GroupMemberMessagingMock.new(nil, nil).set_mock(user_1, user_2)
      allow(TimeEntrySpec::GroupMemberMessagingMock).to receive(:new).and_return(mock_service_instance)
      allow(TimeEntry::DescriptionRules).to receive(:new).with(entry_1).and_return(TimeEntrySpec::NegativeValidatorMock.new)
      allow(TimeEntry::DescriptionRules).to receive(:new).with(entry_2).and_return(TimeEntrySpec::PositiveValidatorMock.new)
      allow(TimeEntry::DescriptionRules).to receive(:new).with(entry_3).and_return(TimeEntrySpec::NegativeValidatorMock.new)
      expect(mock_service_instance).to receive(:send_time_entry_format_warning).with("steve@ombulabs.com", [entry_1, entry_3])
      time_entry.invalid_time_entries_alert("ombuteam")
    end
  end
end

module TimeEntrySpec
  class NegativeValidatorMock
    def valid?
      false
    end
  end
end

module TimeEntrySpec
  class PositiveValidatorMock
    def valid?
      true
    end
  end
end

module TimeEntrySpec
  class GroupMemberMessagingMock
    def initialize(_group_handle, _actionable_hour)
      self
    end

    def send_time_entry_format_warning(_email, _time_entries)
    end

    def set_mock(user_1, user_2)
      @user_1 = user_1
      @user_2 = user_2

      self
    end

    # NOTE: In practice the user objects would be from the service
    #   (ex: SlackService::SlackUser) not User models. We return User models
    #   here for simplicity
    def included_emails
      [@user_1.email, @user_2.email]
    end
  end
end
