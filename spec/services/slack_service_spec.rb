require "rails_helper"

describe SlackService do
  describe ".find_usergroup_id" do
    it "success: given the handle for an existing group - will return the id of that group" do
      result, data = SlackService.find_usergroup_id("ombuteam", SlackServiceSpec::SlackClientMock)
      expect(result).to eql(:ok)
      expect(data).to eql("A00AA0AAA0A")
    end

    it "failure: given a missing handle - returns an error" do
      result, data = SlackService.find_usergroup_id("notombuteam", SlackServiceSpec::SlackClientMock)
      expect(result).to eql(:error)
      expect(data).to eql("Usergroup handle not found")
    end
  end

  describe ".find_usergroup_user_ids" do
    it "success: given a valid usergroup - returns a list of user ids" do |variable|
      result, data = SlackService.find_usergroup_user_ids("A00AA0AAA0A", SlackServiceSpec::SlackClientMock)
      expect(result).to eql(:ok)
      expect(data).to eql(["A00AA1AAA", "A00AA1AAB"])
    end

    # For documentation - no service logic is tested
    it "failure: given a missing usergroup - returns an error" do
      result, data = SlackService.find_usergroup_user_ids("D00DD0DDD0D", SlackServiceSpec::SlackClientMock)
      expect(result).to eql(:error)
      expect(data).to eql("Usergroup Not Found")
    end
  end

  describe ".find_slack_user" do
    it "success: given a user id returns a SlackService::SlackUser" do
      result, data = SlackService.find_slack_user("A00AA1AAA", SlackServiceSpec::SlackClientMock)
      expect(result).to eql(:ok)
      expect(data.class).to eql(SlackService::SlackUser)
      expect(data.id).to eql("A00AA1AAA")
      expect(data.name).to eql("cap")
      expect(data.real_name).to eql("Steve Rogers")
      expect(data.first_name).to eql("Steve")
      expect(data.email).to eql("steve@ombulabs.com")
      expect(data.tz).to eql("America/New_York")
    end

    it "failure: given a missing user - returns an error" do
      result, data = SlackService.find_slack_user("D00DD0DDD0D", SlackServiceSpec::SlackClientMock)
      expect(result).to eql(:error)
      expect(data).to eql("User Not Found")
    end
  end

  describe ".send_message" do
    it "success: given a user id - sends a simple message" do
      result, data = SlackService.send_message("A00AA1AAA", "A message", SlackServiceSpec::SlackClientMock)
      expect(result).to eql(:ok)
      expect(data).to eql("Message Sent")
    end

    it "success: given a user id - sends a complex message" do
      result, data = SlackService.send_message(
        "A00AA1AAA",
        {
          text: "A message",
          attachments: [{"pretext": "pre-hello", "text": "text-world"}],
          blocks: [{"type": "section", "text": {"type": "plain_text", "text": "Hello world"}}]
        },
        SlackServiceSpec::SlackClientMock
      )
      expect(result).to eql(:ok)
      expect(data).to eql("Message Sent")

      # The following asserts send_message receives th
    end

    it "failure: given a missing user - returns an error" do
      result, data = SlackService.send_message("D00DD0DDD0D", "A message", SlackServiceSpec::SlackClientMock)
      expect(result).to eql(:error)
      expect(data).to eql("Slack Channel Not Found")
    end
  end

  describe ".cobble_message_params" do
    it "success: receives simple text messages" do
      result = SlackService.cobble_message_params("The ID", "The Message")
      expect(result).to eql({channel: "The ID", text: "The Message"})
    end

    it "success: receives complex text messages" do
      result = SlackService.cobble_message_params("The ID", {
        text: "A message",
        attachments: [{"pretext": "pre-hello", "text": "text-world"}],
        blocks: [{"type": "section", "text": {"type": "plain_text", "text": "Hello world"}}]
      })
      expect(result).to eql({
        channel: "The ID",
        text: "A message",
        attachments: [{"pretext": "pre-hello", "text": "text-world"}],
        blocks: [{"type": "section", "text": {"type": "plain_text", "text": "Hello world"}}]
      })
    end

    it "failure: requires one of text, attachments, or blocks" do
      expect { SlackService.cobble_message_params("The ID", {}) }.to raise_error(SlackService::MessageFormatError, "Message missing")
    end

    it "failure: rejects aditional keys" do
      expect { SlackService.cobble_message_params("The ID", {text: "The Message", other: "other"}) }.to raise_error(SlackService::MessageFormatError, "Message format incorrect")
    end
  end
end

module SlackServiceSpec
  class SlackClientMock
    def self.chat_postMessage(params)
      if params[:channel] == "A00AA1AAA"
        usergroup_list = Slack::Messages::Message.new
        usergroup_list[:ok] = true
      else
        raise Slack::Web::Api::Errors::ChannelNotFound.new("not_found")
      end
    end

    def self.usergroups_list
      usergroup_list = Slack::Messages::Message.new
      usergroup_list[:ok] = true
      usergroup_list[:usergroups] = [usergroup_mock()]
      usergroup_list
    end

    def self.usergroups_users_list(params)
      if params[:usergroup] == "A00AA0AAA0A"
        users_list = Slack::Messages::Message.new
        users_list[:ok] = true
        users_list[:users] = ["A00AA1AAA", "A00AA1AAB"]
        users_list
      else
        raise Slack::Web::Api::Errors::NoSuchSubteam.new("not_found")
      end
    end

    def self.users_info(params)
      if params[:user] == "A00AA1AAA"
        user = Slack::Messages::Message.new
        user[:ok] = true
        user[:user] = user_mock()
        user
      else
        raise Slack::Web::Api::Errors::UserNotFound.new("not_found")
      end
    end

    def self.profile_mock
      profile = Slack::Messages::Message.new
      profile[:avatar_hash] = "a00a0aa0a000"
      profile[:display_name] = "Cap"
      profile[:display_name_normalized] = "Cap"
      profile[:email] = "steve@ombulabs.com"
      profile[:fields] = nil
      profile[:first_name] = "Steve"
      profile[:huddle_state] = "default_unset"
      profile[:huddle_state_expiration_ts] = 0
      profile[:image_1024] = "https://avatars.slack-edge.com/2022-02-18/0000000000000_a00a0aa0a0000a00a0aa_1024.jpg"
      profile[:image_192] = "https://avatars.slack-edge.com/2022-02-18/0000000000000_a00a0aa0a0000a00a0aa_192.jpg"
      profile[:image_24] = "https://avatars.slack-edge.com/2022-02-18/0000000000000_a00a0aa0a0000a00a0aa_24.jpg"
      profile[:image_32] = "https://avatars.slack-edge.com/2022-02-18/0000000000000_a00a0aa0a0000a00a0aa_32.jpg"
      profile[:image_48] = "https://avatars.slack-edge.com/2022-02-18/0000000000000_a00a0aa0a0000a00a0aa_48.jpg"
      profile[:image_512] = "https://avatars.slack-edge.com/2022-02-18/0000000000000_a00a0aa0a0000a00a0aa_512.jpg"
      profile[:image_72] = "https://avatars.slack-edge.com/2022-02-18/0000000000000_a00a0aa0a0000a00a0aa_72.jpg"
      profile[:image_original] = "https://avatars.slack-edge.com/2022-02-18/0000000000000_a00a0aa0a0000a00a0aa_original.jpg"
      profile[:is_custom_image] = true
      profile[:last_name] = "Rogers"
      profile[:phone] = "1-678-136-7092"
      profile[:pronouns] = "He, him"
      profile[:real_name] = "Steve Rogers"
      profile[:real_name_normalized] = "Steve Rogers"
      profile[:skype] = ""
      profile[:status_emoji] = ""
      profile[:status_expiration] = 0
      profile[:status_text] = ""
      profile[:status_text_canonical] = ""
      profile[:team] = "A00AA0AAA"
      profile[:title] = "Security Specialist"
      profile
    end

    def self.user_mock
      user = Slack::Messages::Message.new
      user[:color] = "99a949"
      user[:deleted] = false
      user[:id] = "A00AA1AAA"
      user[:is_admin] = true
      user[:is_app_user] = false
      user[:is_bot] = false
      user[:is_email_confirmed] = true
      user[:is_owner] = false
      user[:is_primary_owner] = false
      user[:is_restricted] = false
      user[:is_ultra_restricted] = false
      user[:name] = "cap"
      user[:profile] = profile_mock()
      user[:real_name] = "Steve Rogers"
      user[:team_id] = "A00AA0AAA"
      user[:tz] = "America/New_York"
      user[:tz_label] = "Eastern Standard Time"
      user[:tz_offset] = -18000
      user[:updated] = 1645816798
      user[:who_can_share_contact_card] = "EVERYONE"
      user
    end

    def self.usergroup_mock
      usergroup = Slack::Messages::Message.new
      usergroup[:auto_provision] = false
      usergroup[:auto_type] = nil
      usergroup[:channel_count] = 0
      usergroup[:created_by] = "AAAAAAAAA"
      usergroup[:date_create] = 1600791690
      usergroup[:date_delete] = 0
      usergroup[:date_update] = 1639768853
      usergroup[:deleted_by] = nil
      usergroup[:description] = "Notify everyone."
      usergroup[:enterprise_subteam_id] = ""
      usergroup[:handle] = "ombuteam"
      usergroup[:id] = "A00AA0AAA0A"
      usergroup[:is_external] = false
      usergroup[:is_subteam] = true
      usergroup[:is_usergroup] = true
      usergroup[:name] = "OmbuLabs Team"
      usergroup[:team_id] = "T02BW1AAK"
      usergroup[:updated_by] = "AAAAAAAAA"
      usergroup[:user_count] = 2
      usergroup
    end
  end
end
