require "rails_helper"

describe SlackService::GroupMemberMessaging do
  describe ".initialize" do
    it "finds a list of users to send messages to related to a given group" do
      client = instance_double('Slack::Web::Client', auth_test: {team_id: "TEAMID"})
      user1 = SlackService::SlackUser.new({
        id: "USERID1",
        name: "cap",
        real_name: "Steve Rogers",
        tz: "America/New_York",
        email: "steve@ombulabs.com",
        client: client
      })
      user2 = SlackService::SlackUser.new({
        id: "USERID2",
        name: "avenger",
        real_name: "Carol Danvers",
        tz: "America/New_York",
        email: "carol@ombulabs.com",
        client: client
      })
      allow(Slack::Web::Client).to receive(:new).and_return(client)
      allow(SlackService).to receive(:find_usergroup_id).with("avengers", client).and_return([:ok, "GROUPID"])
      allow(SlackService).to receive(:find_usergroup_user_ids).with("GROUPID", client).and_return([:ok, ["USERID1", "USERID2"]])
      allow(SlackService).to receive(:find_slack_user).with("USERID1", client).and_return([:ok, user1])
      allow(SlackService).to receive(:find_slack_user).with("USERID2", client).and_return([:ok, user2])

      result = SlackService::GroupMemberMessaging.new("avengers")
      expect(result.members).to eql({
        "carol@ombulabs.com" => user2,
        "steve@ombulabs.com" => user1
      })
    end
  end
end
