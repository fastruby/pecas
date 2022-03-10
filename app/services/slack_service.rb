##
# This Service serves as an interface for the Slack Web API
#
# @see https://github.com/slack-ruby/slack-ruby-client

class SlackService
  ##
  # Returns the id of a usergroup
  #
  # @param [String] usergroup_handle The text after the `@` used to reference a
  #                 group in slack - ex: ombuteam
  # @param [Slack::Web::Client] client
  # @return [[:ok, String]] if success
  # @return [[:error, String]] if failure
  # @see https://api.slack.com/methods/usergroups.list
  def self.find_usergroup_id(usergroup_handle, client)
    response = client.usergroups_list
    return [:error, response["error"]] unless response["ok"]

    usergroup = response.usergroups.find { |group| group["handle"] == usergroup_handle }
    return [:error, "Usergroup handle not found"] if usergroup.nil?

    [:ok, usergroup.id]
  end

  ##
  # Returns a list of all user ids in a given group
  #
  # @param [String] usergroup_id ID of a Slack group
  # @param [Slack::Web::Client] client
  # @return [[:ok, Array<String>]] if success
  # @return [[:error, String]] if failure
  # @see https://api.slack.com/methods/usergroups.users.list
  def self.find_usergroup_user_ids(usergroup_id, client)
    begin
      response = client.usergroups_users_list({usergroup: usergroup_id})
      [:ok, response["users"]]
    rescue Slack::Web::Api::Errors::NoSuchSubteam 
      [:error, "Usergroup Not Found"]
    end
  end

  ##
  # Returns a SlackUser
  #
  # @param [String] user_id ID of a Slack user
  # @param [Slack::Web::Client] client
  # @return [[:ok, SlackService::SlackUser]] if success
  # @return [[:error, String]] if failure
  # @see https://api.slack.com/methods/users.info
  def self.find_slack_user(user_id, client)
    begin 
      response = client.users_info({user: user_id})
    
      user = SlackUser.new(
        client: client,
        id: response["user"]["id"],
        name: response["user"]["name"],
        first_name: response["user"]["profile"]["first_name"],
        real_name: response["user"]["real_name"],
        tz: response["user"]["tz"],
        email: response["user"]["profile"]["email"]
      )

      [:ok, user]
    rescue Slack::Web::Api::Errors::UserNotFound
      [:error, "User Not Found"]
    end
  end

  ##
  # Posts a message to a given channel
  #
  # The definition of "Channel" includes users in the case od DMs
  #
  # If `message_parts` is a simple string - it will be added as "Text"
  #
  # If `message_parts` is a Hash - should include `:text` but must include
  #   one of `text`, `attachments`, `blocks` - see attached documentation for
  #   more information
  #
  # @param [String] channel_id ID of a Slack user
  # @param [Hash<>, String] message_parts
  # @param [Slack::Web::Client] client
  # @return [[:ok, String]] if success
  # @return [[:error, String]] if failure
  # @see https://api.slack.com/methods/chat.postMessage
  # @see https://github.com/slack-ruby/slack-ruby-client/blob/master/lib/slack/web/api/endpoints/chat.rb
  def self.send_message(channel_id, message_parts, client)
    begin 
      client.chat_postMessage(cobble_message_params(channel_id, message_parts))

      [:ok, "Message Sent"]
    rescue Slack::Web::Api::Errors::ChannelNotFound
      [:error, "Slack Channel Not Found"]
    end
  end

  ##
  # Checks to ensure the keys related to a Slack message are correct and
  #   returns a hash formatted for `chat_postMessage/1`
  def self.cobble_message_params(channel_id, message)
    return {channel: channel_id, text: message} if message.kind_of?(String)

    validate_message_keys(message)

    message[:channel] = channel_id
    message
  end

  def self.validate_message_keys(message)
    contains_required_key = message.keys.inject(false) { |acc, key|
        acc || [:text, :attachments, :blocks].any?(key)
      }
    raise MessageFormatError.new("Message missing") unless contains_required_key

    extra_message_keys = message.keys - [:text, :attachments, :blocks]
    raise MessageFormatError.new("Message format incorrect") unless extra_message_keys.empty?
  end
end
