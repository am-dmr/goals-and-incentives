module Web
  module V1
    class GoalsController < ApplicationController
      before_action :authenticate_web_v1_user!

      def index
        @goals = current_web_v1_user.goals.order(size: :asc)
      end

      def show
        @goal = current_web_v1_user.goals.find(params[:id])
      end

      def new
        @goal ||= current_web_v1_user.goals.build
      end

      def create
        @goal = current_web_v1_user.goals.create(params.require(:goal).permit(:name, :aim, :limit, :period, :size))

        if @goal.persisted?
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

        if @goal.update(params.require(:goal).permit(:name, :aim, :limit, :period, :size))
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
    end
  end
end
