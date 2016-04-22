require 'togglv8'
require 'reportsv2'

module TogglBot
  class Toggl
    def initialize
      @workpace_id = ENV['TOGGL_WORKSPACE_ID']
    end

    def get_toggled_time(user, since_time, until_time)
      report = reports.summary(@workpace_id,
                               since: since_time.to_s,
                               until: until_time.to_s,
                               grouping: 'users',
                               user_ids: user['id'])
      if report['data'].count > 0
        report['data'].first['time'] / 1000.to_f
      else
        0
      end
    end

    def users
      toggl.users(@workpace_id)
    end

    def active(user)
      
    end

    private

    def toggl
      @toggl ||= ::TogglV8::API.new(ENV['TOGGL_API_TOKEN'])
    end

    def reports
      @toggl ||= ::ReportsV2::API.new(ENV['TOGGL_API_TOKEN'])
    end
  end
end
