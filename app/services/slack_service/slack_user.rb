class SlackService::SlackUser
  attr_reader :id, :name, :first_name, :real_name, :tz, :email

  def initialize(params)
    @id = params.fetch(:id)
    @name = params.fetch(:name)
    @real_name = params.fetch(:real_name)
    @first_name = params.fetch(:first_name)
    @tz = params.fetch(:tz)
    @email = params.fetch(:email)
    @client = params.fetch(:client)
  end

  def message(message)
    ::SlackService.send_message(@id, message, @client)
  end
end