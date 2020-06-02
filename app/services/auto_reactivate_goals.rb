class AutoReactivateGoals < BaseService
  param :user

  def call
    return unless user

    user
      .goals
      .period_once
      .where(is_completed: true)
      .where.not(auto_reactivate_every_n_days: nil)
      .joins(<<~SQL)
        LEFT JOIN dailies ON dailies.goal_id = goals.id AND dailies.date = '#{Date.current}'
      SQL
      .where(dailies: { id: nil })
      .find_each do |goal|
      reactivate_goal(goal)
    end
  end

  private

  def reactivate_goal(goal)
    reactivation_date = goal.auto_reactivate_start_from
    reactivation_date += goal.auto_reactivate_every_n_days.days while reactivation_date < Date.current
    reactivation_date -= goal.auto_reactivate_every_n_days.days

    last_daily = goal.dailies.last
    return if last_daily && last_daily.date >= reactivation_date

    goal.update(is_completed: false)
    GenerateDaily.call(goal)
  end
end
