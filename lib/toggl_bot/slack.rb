require 'slack-ruby-client'

module TogglBot
  class Slack
    def initialize
      ::Slack.configure do |config|
        config.token = ENV['SLACK_API_TOKEN']
      end
    end

    def active_users
      @active_users ||= slack_users
    end

    def send_private_message(user, text = 'default message')
      client.chat_postMessage(channel: user['id'], text: text, as_user: true)
    end

    private

    def client
      @client ||= ::Slack::Web::Client.new
    end

    def slack_users
      @slack_users ||= client.users_list['members']
                       .select { |x| x['is_bot'] == false }
    end
  end
end
