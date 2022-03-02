require "rails_helper"

describe SlackService::GroupMemberMessaging do
  let(:client) { instance_double('Slack::Web::Client', auth_test: {team_id: "TEAMID"}) }
  let(:six_oclock_hour) { 18 }
  let(:now) {
    tz = TZInfo::Timezone.get("America/New_York").current_period.offset.utc_total_offset
    Time.new(2022, 3, 1, six_oclock_hour, 3, 0, tz)
  }
  let(:user_1) {
    SlackService::SlackUser.new({
      id: "USERID1",
      name: "cap",
      real_name: "Steve Rogers",
      first_name: "Steve",
      tz: "America/New_York",
      email: "steve@ombulabs.com",
      client: client
    })
  }
  let(:user_2) {
    SlackService::SlackUser.new({
      id: "USERID2",
      name: "avenger",
      real_name: "Carol Danvers",
      first_name: "Carol",
      tz: "America/Sao_Paulo",
      email: "carol@ombulabs.com",
      client: client
    })
  }

  describe ".initialize" do
    it "sets a new instance including all group members returned by Slack" do
      allow(Slack::Web::Client).to receive(:new).and_return(client)
      allow(SlackService).to receive(:find_usergroup_id).with("avengers", client).and_return([:ok, "GROUPID"])
      allow(SlackService).to receive(:find_usergroup_user_ids).with("GROUPID", client).and_return([:ok, ["USERID1", "USERID2"]])
      allow(SlackService).to receive(:find_slack_user).with("USERID1", client).and_return([:ok, user_1])
      allow(SlackService).to receive(:find_slack_user).with("USERID2", client).and_return([:ok, user_2])

      expect(Slack::Web::Client).to receive(:new).and_return(client)
      expect(SlackService).to receive(:find_usergroup_id).with("avengers", client).and_return([:ok, "GROUPID"])
      expect(SlackService).to receive(:find_usergroup_user_ids).with("GROUPID", client).and_return([:ok, ["USERID1", "USERID2"]])
      expect(SlackService).to receive(:find_slack_user).with("USERID1", client).and_return([:ok, user_1])
      expect(SlackService).to receive(:find_slack_user).with("USERID2", client).and_return([:ok, user_2])

      result = SlackService::GroupMemberMessaging.new("avengers", six_oclock_hour, now)

      # user 2 should be missing because her tz is not currently experiencing 6 o'clock
      expect(result.members).to eql({"steve@ombulabs.com" => user_1})
    end
  end

  describe "#included_emails" do
    it "returns a list of all emails in the service instance" do
      allow(Slack::Web::Client).to receive(:new).and_return(client)
      allow(SlackService).to receive(:find_usergroup_id).with("avengers", client).and_return([:ok, "GROUPID"])
      allow(SlackService).to receive(:find_usergroup_user_ids).with("GROUPID", client).and_return([:ok, ["USERID1", "USERID2"]])
      allow(SlackService).to receive(:find_slack_user).with("USERID1", client).and_return([:ok, user_1])
      allow(SlackService).to receive(:find_slack_user).with("USERID2", client).and_return([:ok, user_2])

      result = SlackService::GroupMemberMessaging.new("avengers", six_oclock_hour, now)

      # user 2 should be missing because her tz is not currently experiencing 6 o'clock
      expect(result.included_emails).to eql(["steve@ombulabs.com"])
    end
  end

  describe "#send_time_entry_format_warning" do
    let(:entry_1)   { create(:entry) }
    let(:entry_2)   { create(:entry) }
    let(:entry_3)   { create(:entry) }

    it "forwards a formatted message to the intended slack member" do
      allow(Slack::Web::Client).to receive(:new).and_return(client)
      allow(SlackService).to receive(:find_usergroup_id).with("avengers", client).and_return([:ok, "GROUPID"])
      allow(SlackService).to receive(:find_usergroup_user_ids).with("GROUPID", client).and_return([:ok, ["USERID1", "USERID2"]])
      allow(SlackService).to receive(:find_slack_user).with("USERID1", client).and_return([:ok, user_1])
      allow(SlackService).to receive(:find_slack_user).with("USERID2", client).and_return([:ok, user_2])
      service = SlackService::GroupMemberMessaging.new("avengers", six_oclock_hour, now)
      allow(service).to receive(:time_entry_format_warning_message).with(user_1, [entry_1, entry_2, entry_3]).and_return("The Message")
      expect(user_1).to receive(:message).with("The Message")
      service.send_time_entry_format_warning("steve@ombulabs.com", [entry_1, entry_2, entry_3])
    end
  end

  describe "_time_entry_format_warning_message" do
    let(:entry_1)   { create(:entry, description: "A non-descriptive description 1", minutes: 120) }
    let(:entry_2)   { create(:entry, description: "A non-descriptive description 2", minutes: 90) }
    let(:entry_3)   { create(:entry, description: "A non-descriptive description 3", minutes: 20) }

    it "forwards a formatted message to the intended slack member" do
      allow(Slack::Web::Client).to receive(:new).and_return(client)
      allow(SlackService).to receive(:find_usergroup_id).with("avengers", client).and_return([:ok, "GROUPID"])
      allow(SlackService).to receive(:find_usergroup_user_ids).with("GROUPID", client).and_return([:ok, ["USERID1", "USERID2"]])
      allow(SlackService).to receive(:find_slack_user).with("USERID1", client).and_return([:ok, user_1])
      allow(SlackService).to receive(:find_slack_user).with("USERID2", client).and_return([:ok, user_2])
      service = SlackService::GroupMemberMessaging.new("avengers", six_oclock_hour, now)

      message = service.send :time_entry_format_warning_message, user_1, [entry_1, entry_2, entry_3]

      # {:text => {:text => "The Description", :type => "plain_text"}, :type => "section"}
      intro_block = message[:blocks][0][:text]
      list_block = message[:blocks][1][:text]
      expect(intro_block[:type]).to eql("plain_text")
      expect(intro_block[:text]).to include(user_1.first_name)
      expect(list_block[:type]).to eql("mrkdwn")
      expect(list_block[:text]).to include(entry_1.description)
      expect(list_block[:text]).to include("2 hours")
      expect(list_block[:text]).to include(entry_2.description)
      expect(list_block[:text]).to include("1 hour, 30 minutes")
      expect(list_block[:text]).to include(entry_3.description)
      expect(list_block[:text]).to include("20 minutes")
    end
  end

  # let(:user) {
  #   SlackService::SlackUser.new({
  #     id: "A00AA1AAA",
  #     name: "cap",
  #     real_name: "Steve Rogers",
  #     first_name: "Steve",
  #     tz: "America/New_York",
  #     email: "steve@ombulabs.com",
  #     client: TimeEntrySpec::SlackClientMock
  #   })
  # }

  # let(:user_1) { create(:user, email: "steve@ombulabs.com") }
  # let(:entry_1)   { create(:entry, user: user_1, date: Date.new(2022, 3, 1), description: "A non-descriptive description 1", minutes: 120) }
  # let(:entry_2)   { create(:entry, user: user_1, date: Date.new(2022, 3, 1), description: "A non-descriptive description 2", minutes: 90) }
  # let(:entry_3)   { create(:entry, user: user_1, date: Date.new(2022, 3, 1), description: "A non-descriptive description 3", minutes: 20) }

  # describe ".bad_entry_message_template" do
  #   it "formats a multi-part message to sent the user" do
  #     message = TimeEntry.bad_entry_message_template(user, [entry_1, entry_2, entry_3])
  #     # {:text => {:text => "The Description", :type => "plain_text"}, :type => "section"}
  #     intro_block = message[:blocks][0][:text]
  #     list_block = message[:blocks][1][:text]
  #     expect(intro_block[:type]).to eql("plain_text")
  #     expect(intro_block[:text]).to include(user.first_name)
  #     expect(list_block[:type]).to eql("mrkdwn")
  #     expect(list_block[:text]).to include(entry_1.description)
  #     expect(list_block[:text]).to include("2 hours")
  #     expect(list_block[:text]).to include(entry_2.description)
  #     expect(list_block[:text]).to include("1 hour, 30 minutes")
  #     expect(list_block[:text]).to include(entry_3.description)
  #     expect(list_block[:text]).to include("20 minutes")
  #   end
  # end
end
