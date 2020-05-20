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
    end
  end
end
