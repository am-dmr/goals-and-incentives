module Web
  module V1
    class IncentivesController < ApplicationController
      before_action :authenticate_web_v1_user!

      def index
        @incentives = current_web_v1_user.incentives.order(size: :asc)
      end

      def new
        @incentive ||= current_web_v1_user.incentives.build
      end

      def create
        @incentive = current_web_v1_user.incentives.create(params.require(:incentive).permit(:name, :size))

        if @incentive.persisted?
          redirect_to web_v1_incentives_path
        else
          render :new
        end
      end
    end
  end
end
