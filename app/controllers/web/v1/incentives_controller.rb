module Web
  module V1
    class IncentivesController < BaseController
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
          flash[:notice] = t('incentives.create_ok')
          redirect_to web_v1_incentive_path(@incentive)
        else
          flash[:alert] = t('incentives.create_error')
          render :new
        end
      end

      def edit
        @incentive ||= current_web_v1_user.incentives.find(params[:id])
      end

      def update
        @incentive = current_web_v1_user.incentives.find(params[:id])

        if @incentive.update(params.require(:incentive).permit(:name, :size))
          flash[:notice] = t('incentives.update_ok')
          redirect_to web_v1_incentive_path(@incentive)
        else
          flash[:alert] = t('incentives.update_error')
          render :edit
        end
      end

      def destroy
        @incentive = current_web_v1_user.incentives.find(params[:id])

        if @incentive.destroy
          flash[:notice] = t('incentives.delete_ok')
          redirect_to web_v1_incentives_path
        else
          flash[:alert] = t('incentives.delete_error')
          redirect_to web_v1_incentive_path(@incentive)
        end
      end
    end
  end
end
