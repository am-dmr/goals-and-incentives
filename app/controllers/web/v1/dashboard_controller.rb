module Web
  module V1
    class DashboardController < ApplicationController
      def index
        repo = DailyRepository.new

        @dailies = repo.current_day(current_web_v1_user)
        @stats = GenerateStats.call(repo.stats(current_web_v1_user))
      end
    end
  end
end
