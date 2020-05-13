module Web
  module V1
    class GoalsController < ApplicationController
      before_action :authenticate_web_v1_user!

      def index
        @goals = current_web_v1_user.goals.order(size: :asc)
      end
    end
  end
end
