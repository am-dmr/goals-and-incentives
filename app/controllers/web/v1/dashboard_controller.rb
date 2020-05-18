module Web
  module V1
    class DashboardController < ApplicationController
      def index
        repo = DailyRepository.new
        @dailies = repo.current_day(current_web_v1_user)

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
