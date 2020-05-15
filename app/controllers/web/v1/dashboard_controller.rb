module Web
  module V1
    class DashboardController < ApplicationController
      def index
        repo = DailyRepository.new
        @dailies_per_day = repo.per_day_dailies(current_web_v1_user)
        @dailies_per_week = repo.per_week_dailies(current_web_v1_user)
        @dailies_once = repo.once_dailies(current_web_v1_user)

        @stats =
          if current_web_v1_user
            current_web_v1_user.dailies.where(date: (9.days.ago..)).includes(:goal, :incentive)
          else
            Daily.none
          end
      end
    end
  end
end
