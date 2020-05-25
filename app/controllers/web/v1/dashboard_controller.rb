module Web
  module V1
    class DashboardController < BaseController
      def index
        GenerateDailies.call(current_web_v1_user)
        FreezeDailies.call(current_web_v1_user)

        repo = DailyRepository.new

        @today_dailies = repo.current_day(current_web_v1_user)
        @yesterday_dailies = repo.previous_day(current_web_v1_user)
        @stats = CollectStats.call(repo.stats(current_web_v1_user))
      end
    end
  end
end
