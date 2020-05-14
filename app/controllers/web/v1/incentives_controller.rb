module Web
  module V1
    class IncentivesController < ApplicationController
      before_action :authenticate_web_v1_user!

      def index
        @incentives = current_web_v1_user.incentives.order(size: :asc)
      end

      def show
        @incentive = current_web_v1_user.incentives.find(params[:id])
      end

      def new
        @incentive ||= current_web_v1_user.incentives.build
      end

      def create
        @incentive = current_web_v1_user.incentives.create(params.require(:incentive).permit(:name, :size))

        if @incentive.persisted?
          # TODO: flash OK
          redirect_to web_v1_incentives_path
        else
          # TODO: flash ERROR
          render :new
        end
      end

      def edit
        @incentive ||= current_web_v1_user.incentives.find(params[:id])
      end

      def update
        @incentive = current_web_v1_user.incentives.find(params[:id])

        if @incentive.update(params.require(:incentive).permit(:name, :size))
          # TODO: flash OK
          redirect_to web_v1_incentives_path
        else
          # TODO: flash ERROR
          render :edit
        end
      end

      def destroy
        @incentive = current_web_v1_user.incentives.find(params[:id])

        if @incentive.destroy
          # TODO: flash OK
          redirect_to web_v1_incentives_path
        else
          # TODO: flash ERROR
        end
      end
    end
  end
end
