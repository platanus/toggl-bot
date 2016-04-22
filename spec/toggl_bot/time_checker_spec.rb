require 'spec_helper'

describe TogglBot::TimeChecker do
  describe "#status" do
    let(:user) { double('email' => 'user@platan.us', 'inactive' => false) }
    let(:tz_offset) { -10800 }
    let(:time_checker) do
      TogglBot::TimeChecker.new(user, tz_offset)
    end

    it "return a do not disturbe status on non working hours" do
      allow(time_checker).to receive(:current_session).and_return(nil)
      status = time_checker.status
      expect(status).to eql(:do_not_disturb)
    end

    it "return a toggling status if the user is currently toggling" do
      allow(time_checker).to receive(:current_session).and_return(:evening)
      allow(time_checker).to receive(:active?).and_return(true)
      status = time_checker.status
      expect(status).to eql(:toggling)
    end

    it "return a idle status if the user is not currently toggling" do
      allow(time_checker).to receive(:current_session).and_return(:evening)
      allow(time_checker).to receive(:active?).and_return(false)
      status = time_checker.status
      expect(status).to eql(:idle)
    end
  end

  describe "#current_session" do
    let(:user) { { 'email' => 'user@platan.us' } }
    let(:tz_offset) { -10800 }
    let(:time_checker) do
      TogglBot::TimeChecker.new(user, tz_offset)
    end

    it "return morning session" do
      allow(Time).to receive(:now).and_return(Time.find_zone(tz_offset).local(2015, 12, 25, 9, 35, 00))
      current_session = time_checker.current_session
      expect(current_session).to eql(:morning)
    end

    it "return morning session" do
      allow(Time).to receive(:now).and_return(Time.find_zone(tz_offset).local(2015, 12, 25, 17, 35, 00))
      current_session = time_checker.current_session
      expect(current_session).to eql(:evening)
    end

    it "return nil session to early in the morning" do
      allow(Time).to receive(:now).and_return(Time.find_zone(tz_offset).local(2015, 12, 25, 7, 35, 00))
      current_session = time_checker.current_session
      expect(current_session).to eql(nil)
    end

    it "return nil session at lunch time" do
      allow(Time).to receive(:now).and_return(Time.find_zone(tz_offset).local(2015, 12, 25, 13, 35, 00))
      current_session = time_checker.current_session
      expect(current_session).to eql(nil)
    end

    it "return nil session to late in the evening" do
      allow(Time).to receive(:now).and_return(Time.find_zone(tz_offset).local(2015, 12, 25, 18, 35, 00))
      current_session = time_checker.current_session
      expect(current_session).to eql(nil)
    end
  end
end
