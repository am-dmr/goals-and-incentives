module Web
  module V1
    class DailiesController < BaseController
      before_action :authenticate_web_v1_user!

      def increment
        @daily = current_web_v1_user.dailies.find(params[:id])
        UpdateDaily.call(@daily, :increment)
      end

      def decrement
        @daily = current_web_v1_user.dailies.find(params[:id])
        UpdateDaily.call(@daily, :decrement)
      end

      def edit_incentive
        @daily = current_web_v1_user.dailies.find(params[:id])
      end

      def update_incentive
        @daily = current_web_v1_user.dailies.find(params[:id])
        incentive =
          if params.require(:daily).permit(:incentive).present?
            current_web_v1_user.incentives.find_by(id: params[:daily][:incentive])
          end

        @daily.update(incentive: incentive)
      end

      def toggle_incentive_status
        @daily = current_web_v1_user.dailies.find(params[:id])
        @daily.update(incentive_status: @daily.incentive_status_success? ? :failed : :success)
      end

      def freeze
        FreezeDailies.call(current_web_v1_user, true)
        redirect_to web_v1_dashboard_index_path
      end
    end
  end
end
