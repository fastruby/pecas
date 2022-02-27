require "rails_helper"

describe SlackService::SlackUser do
  let(:valid_params) {
    {
      id: "A00AA1AAA",
      name: "cap",
      real_name: "Steve Rogers",
      tz: "America/New_York",
      email: "steve@ombulabs.com",
      client: SlackServiceSpec::SlackUserSpec::SlackClientMock
    }
  }

  describe ".initialize" do
    it "requires all expected keys" do
      [:id, :name, :real_name, :tz, :email, :client].map { |key|
        expect { SlackService::SlackUser.new(valid_params.except!(key)) }.to raise_error(KeyError)
      }
    end
  end

  describe "#message" do
    it "success: forwards the message to SlackService.send_message" do
      user = SlackService::SlackUser.new(valid_params)
      expect(SlackService).to receive(:send_message).with(valid_params[:id], "A message", valid_params[:client])

      user.message("A message")
    end
  end
end

module SlackServiceSpec
  module SlackUserSpec
    class SlackClientMock
      def self.chat_postMessage(params)
        if params[:channel] == "A00AA1AAA"
          usergroup_list = Slack::Messages::Message.new
          usergroup_list[:ok] = true
        else
          raise Slack::Web::Api::Errors::ChannelNotFound.new("not_found")
        end
      end
    end
  end
end
