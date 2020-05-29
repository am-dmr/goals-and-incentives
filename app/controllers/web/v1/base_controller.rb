module Web
  module V1
    class BaseController < ApplicationController
      rescue_from ActionController::ParameterMissing, with: :render_400
      rescue_from ActiveRecord::RecordNotFound, with: :render_404

      private

      def render_400
        head :bad_request
      end

      def render_404
        head :not_found
      end

      def update_last_visited_at
        return unless current_web_v1_user

        current_web_v1_user.update(last_visited_at: Time.current)
      end
    end
  end
end
