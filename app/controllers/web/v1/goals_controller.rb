module Web
  module V1
    class GoalsController < BaseController
      before_action :authenticate_web_v1_user!

      def index
        @goals =
          current_web_v1_user
          .goals
          .order(
            Arel.sql(<<~SQL)
              goals.period = #{Goal.periods[:per_day]} DESC,
              goals.period = #{Goal.periods[:per_week]} DESC,
              goals.size DESC,
              goals.name ASC
            SQL
          )
      end

      def show
        @goal = current_web_v1_user.goals.find(params[:id])
      end

      def new
        @goal ||= current_web_v1_user.goals.build
      end

      def create
        @goal = current_web_v1_user.goals.create(goal_params)

        if @goal.persisted?
          GenerateDailies.call(current_web_v1_user)
          flash[:notice] = t('goals.create_ok')
          redirect_to web_v1_goal_path(@goal)
        else
          flash[:alert] = t('goals.create_error')
          render :new
        end
      end

      def edit
        @goal ||= current_web_v1_user.goals.find(params[:id])
      end

      def update
        @goal = current_web_v1_user.goals.find(params[:id])

        if @goal.update(goal_params)
          GenerateDailies.call(current_web_v1_user)
          flash[:notice] = t('goals.update_ok')
          redirect_to web_v1_goal_path(@goal)
        else
          flash[:alert] = t('goals.update_error')
          render :edit
        end
      end

      def reactualize
        @goal = current_web_v1_user.goals.period_once.find(params[:id])

        if @goal.update(is_completed: false)
          GenerateDailies.call(current_web_v1_user)
          flash[:notice] = t('goals.update_ok')
          redirect_to web_v1_goal_path(@goal)
        else
          flash[:alert] = t('goals.update_error')
          render :edit
        end
      end

      def destroy
        @goal = current_web_v1_user.goals.find(params[:id])

        if @goal.destroy
          flash[:notice] = t('goals.delete_ok')
          redirect_to web_v1_goals_path
        else
          flash[:alert] = t('goals.delete_error')
          redirect_to web_v1_goal_path(@goal)
        end
      end

      private

      def goal_params
        pp = params.require(:goal).permit(:name, :aim, :limit, :period, :size, :incentive)
        pp[:incentive_id] = pp[:incentive]
        pp.delete(:incentive)
        pp
      end
    end
  end
end
