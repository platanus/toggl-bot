require_relative 'toggl'
require 'active_support/all'
require 'pry'

module TogglBot
  class TimeChecker
    MORNING_START_HOUR = 9.hours
    EVENING_START_HOUR = 14.hours
    SESSION_TIME = 4.hours

    def initialize(user, tz_offset)
      @user = user
      @tz_offset = tz_offset
    end

    def status
      if current_session != :morning && current_session != :evening
        :do_not_disturb
      elsif active?
        :toggling
      else
        :idle
      end
    end

    def current_session
      if now.between?(morning_start, morning_end)
        :morning
      elsif now.between?(evening_start, evening_end)
        :evening
      end
    end

    def time
      toggl.get_toggled_time(user, now.beginning_of_day, now.end_of_day)
    end

    private

    def user
      @user
    end

    def morning_start
      now.beginning_of_day + MORNING_START_HOUR
    end

    def morning_end
      morning_start + SESSION_TIME
    end

    def evening_start
      now.beginning_of_day + EVENING_START_HOUR
    end

    def evening_end
      evening_start + SESSION_TIME
    end

    def now
      # binding.pry
      Time.now.in_time_zone(@tz_offset)
    end

    def active?
      ! toggl(user).active?
    end

    def toggl
      @toggl ||= TogglBot::Toggl.new
    end
  end
end

# require_relative 'bot'
# require_relative 'member'
#
# module TogglBot
#   class State
#     def initialize(email)
#       toggl_workspace_users = toggl.users(ENV['TOGGL_WORKSPACE_ID'])
#     end
#
#
#     def members
#       @members ||= toggl.users(ENV['TOGGL_WORKSPACE_ID']).map do |user|
#         TogglBot::Member.new(user)
#       end
#     end
#
#     def update
#
#     end
#
#     private
#
#     def toggl
#       @toggl ||= TogglV8::API.new(ENV['TOGGL_API_TOKEN'])
#     end
#
#     def toggl_reports
#       @toggl_reports ||= ReportsV2::API.new(ENV['TOGGL_API_TOKEN'])
#     end
#
#
#     def should_say_something?
#       now < morning
#     end
#
#     def morning
#       now.beginning_of_day + MORNING_OFFSET
#     end
#
#     def evening
#       now.beginning_of_day + EVENING_OFFSET
#     end
#
#     def now
#       Time.now.in_time_zone(@user.tz)
#     end
#
#     def get_user_by_email(email)
#       slack_users.find { |u| u['profile']['email'] == email }
#     end
#   end
# end
