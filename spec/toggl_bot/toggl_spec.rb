require 'spec_helper'

describe TogglBot::Toggl do
  describe "#active?" do
    let(:user) { double }
    let(:toggl) { double }
    let(:notifier) do
      TogglBot::Toggl.new
    end

    before do
      allow(notifier).to receive(:toggl).and_return(toggl)
    end

    it "notify a missing entry to the user" do
    end
  end
end
