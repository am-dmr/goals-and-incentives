module Web
  module V1
    class DashboardController < BaseController
      def index
        update_last_visited_at
        PrepareUserDailies.call(current_web_v1_user)

        repo = DailyRepository.new

        @today_dailies = repo.current_day(current_web_v1_user)
        @yesterday_dailies = repo.previous_day(current_web_v1_user)
      end
    end
  end
end
