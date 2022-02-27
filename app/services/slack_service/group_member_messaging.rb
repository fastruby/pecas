class SlackService::GroupMemberMessaging
  attr_reader :members

  ##
  # @option options [string] :team
  # @option options [string] :timezone
  def initialize(group_handle)
    connect_client()
    set_usergroup_id(group_handle)
    set_user_ids()
    set_members()
  end

    private

    def connect_client
      @client = Slack::Web::Client.new
      raise "Slack API connection failed" if @client.auth_test[:team_id].nil?
    end

    def set_members
      @members = @user_ids.inject({}) do |users, user_id|
        result, data = ::SlackService.find_slack_user(user_id, @client)

        raise data unless result == :ok

        users[data.email] = data
        users
      end
    end

    def set_user_ids
      result, data = ::SlackService.find_usergroup_user_ids(@usergroup_id, @client)
      raise data unless result == :ok

      @user_ids = data
    end

    def set_usergroup_id(group_handle)
      result, data = ::SlackService.find_usergroup_id(group_handle, @client)
      raise data unless result == :ok

      @usergroup_id = data
    end
end
