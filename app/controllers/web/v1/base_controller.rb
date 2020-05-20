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
    end
  end
end
