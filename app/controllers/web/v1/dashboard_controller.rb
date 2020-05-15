module Web
  module V1
    class DashboardController < ApplicationController
      def index
        @dailies =
          if current_web_v1_user
            current_web_v1_user.dailies.today.includes(:goal, :incentive)
          else
            Daily.none
          end

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
