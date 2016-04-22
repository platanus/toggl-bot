require 'spec_helper'

describe TogglBot::Notifier do
  describe "#notify_missing_entry" do
    let(:slack_service) { double }
    let(:user) { double }
    let(:notifier) do
      TogglBot::Notifier.new(slack_service, user)
    end

    before do
      allow(slack_service).to receive(:send_private_message).and_return(success: true)
    end

    it "notify a missing entry to the user" do
      notifier.notify_missing_entry
      expect(slack_service).to have_received(:send_private_message).with(
        user,
        TogglBot::Notifier::MISSING_ENTRY_MESSAGE
      )
    end
  end
end
