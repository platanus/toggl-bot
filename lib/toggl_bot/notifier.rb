module TogglBot
  class Notifier
    MISSING_ENTRY_MESSAGE = "Looks like you are not toggling. Just remember to do it ;)."

    def initialize(slack, user)
      @slack = slack
      @user = user
    end

    def notify_missing_entry
      slack.send_private_message(user, MISSING_ENTRY_MESSAGE)
    end

    def notify_total_toggl(time)
      if time > 0
        slack.send_private_message(user, get_time_text(time))
      end
    end

    def notify_reaction_toggl

    end

    private

    def get_time_text(time)
      time_string = ChronicDuration.output(time, format: :long, units: 2)
      "You have toggled #{time_string} so far"
    end

    def slack
      @slack
    end

    def user
      @user
    end
  end
end
