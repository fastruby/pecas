require "rails_helper"

describe TimeEntry do
  let(:user) {
    SlackService::SlackUser.new({
      id: "A00AA1AAA",
      name: "cap",
      real_name: "Steve Rogers",
      first_name: "Steve",
      tz: "America/New_York",
      email: "steve@ombulabs.com",
      client: TimeEntrySpec::SlackClientMock
    })
  }

  let(:user_1) { create(:user, email: "steve@ombulabs.com") }
  let(:entry_1)   { create(:entry, user: user_1, date: Date.new(2022, 3, 1), description: "A non-descriptive description 1", minutes: 120) }
  let(:entry_2)   { create(:entry, user: user_1, date: Date.new(2022, 3, 1), description: "A non-descriptive description 2", minutes: 90) }
  let(:entry_3)   { create(:entry, user: user_1, date: Date.new(2022, 3, 1), description: "A non-descriptive description 3", minutes: 20) }

  describe ".bad_entry_message_template" do
    it "formats a multi-part message to sent the user" do
      message = TimeEntry.bad_entry_message_template(user, [entry_1, entry_2, entry_3])
      # {:text => {:text => "The Description", :type => "plain_text"}, :type => "section"}
      intro_block = message[:blocks][0][:text]
      list_block = message[:blocks][1][:text]
      expect(intro_block[:type]).to eql("plain_text")
      expect(intro_block[:text]).to include(user.first_name)
      expect(list_block[:type]).to eql("mrkdwn")
      expect(list_block[:text]).to include(entry_1.description)
      expect(list_block[:text]).to include("2 hours")
      expect(list_block[:text]).to include(entry_2.description)
      expect(list_block[:text]).to include("1 hour, 30 minutes")
      expect(list_block[:text]).to include(entry_3.description)
      expect(list_block[:text]).to include("20 minutes")
    end
  end

  describe ".maybe_message" do
    it "sends a formatted message if there are incorrectly formatted entries" do
      messaging_service = TimeEntrySpec::GroupMemberMessagingMock.new(user)
      allow_any_instance_of(TimeEntry::DescriptionRules).to receive(:valid?).and_return(false)
      allow(TimeEntry).to receive(:bad_entry_message_template).with(user, [entry_1]).and_return("Message for user")
      allow(user).to receive(:message).with("Message for user")

      expect(TimeEntry).to receive(:bad_entry_message_template)
      expect(user).to receive(:message)
      TimeEntry.maybe_message("steve@ombulabs.com", [entry_1], messaging_service, TimeEntry::DescriptionRules)
    end

    it "does not send a message if there are no incorrectly formatted entries" do
      messaging_service = TimeEntrySpec::GroupMemberMessagingMock.new(user)
      allow_any_instance_of(TimeEntry::DescriptionRules).to receive(:valid?).and_return(true)

      expect(TimeEntry).not_to receive(:bad_entry_message_template)
      expect(user).not_to receive(:message)
      TimeEntry.maybe_message("steve@ombulabs.com", [entry_1], messaging_service, TimeEntry::DescriptionRules)
    end
  end

  describe ".alert_problematic_time_entries" do
    it "collects entries for a specific day and forwards to maybe_message" do
      allow(SlackService::GroupMemberMessaging).to receive(:new).with("ombuteam", 18).and_return(TimeEntrySpec::SlackClientMock)
      expect(SlackService::GroupMemberMessaging).to receive(:new)
      expect(TimeEntry).to receive(:maybe_message).with("steve@ombulabs.com", [entry_1, entry_2, entry_3], TimeEntrySpec::SlackClientMock)
      TimeEntry.alert_problematic_time_entries("ombuteam", Date.new(2022, 3, 1), 18, SlackService::GroupMemberMessaging)
    end
  end
end

module TimeEntrySpec
  class SlackClientMock
    def self.included_emails
      ["steve@ombulabs.com"]
    end
  end
end

module TimeEntrySpec
  class GroupMemberMessagingMock
    def initialize(user)
      @user = user
    end

    def user(email)
      @user
    end

    def included_emails
      [@user.email]
    end
  end
end
