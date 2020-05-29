module Web
  module V1
    class AnalyticsController < BaseController
      before_action :authenticate_web_v1_user!

      def index
        @stats = CollectStats.call(DailyRepository.new.stats(current_web_v1_user))
      end
    end
  end
end
