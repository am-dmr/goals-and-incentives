class CollectStats < BaseService
  param :relation

  def call
    stats = {}

    relation.each do |daily|
      goal = stats[daily.goal_id]

      unless goal
        goal = { name: daily.goal.name, period: daily.goal.period }
        stats[daily.goal_id] = goal
      end

      if daily.goal.period_per_week?
        fill_week(daily, goal)
      else
        goal[daily.date.strftime('%d%m')] = { status: daily.status, incentive_status: daily.incentive_status }
      end
    end

    stats
  end

  private

  def fill_week(daily, goal)
    (daily.date..daily.date.end_of_week).each do |day|
      goal[day.strftime('%d%m')] = { status: daily.status, incentive_status: daily.incentive_status }
    end
  end
end
