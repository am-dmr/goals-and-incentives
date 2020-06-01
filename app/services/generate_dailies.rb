class GenerateDailies < BaseService
  param :user

  def call
    return unless user

    generate_per_day_dailies
    generate_per_week_dailies
    generate_or_move_once_dailies
  end

  private

  def generate_per_day_dailies
    user
      .goals
      .period_per_day
      .joins(<<~SQL)
        LEFT JOIN dailies ON dailies.goal_id = goals.id AND dailies.date = '#{Date.current}'
      SQL
      .where(dailies: { id: nil })
      .find_each do |goal|
      goal.dailies.create(date: Date.current, status: :pending, value: 0, incentive: goal.incentive)
    end
  end

  def generate_per_week_dailies
    user
      .goals
      .period_per_week
      .joins(<<~SQL)
        LEFT JOIN dailies ON dailies.goal_id = goals.id AND dailies.date = '#{Date.current.beginning_of_week}'
      SQL
      .where(dailies: { id: nil })
      .find_each do |goal|
      goal.dailies.create(date: Date.current.beginning_of_week, status: :pending, value: 0, incentive: goal.incentive)
    end
  end

  def generate_or_move_once_dailies
    user
      .goals
      .period_once
      .where(is_completed: false)
      .joins(<<~SQL)
        LEFT JOIN dailies ON dailies.goal_id = goals.id AND dailies.date = '#{Date.current}'
      SQL
      .where(dailies: { id: nil })
      .find_each do |goal|
      last_daily = goal.dailies.last
      if !last_daily || last_daily.status_success?
        goal.dailies.create(date: Date.current, status: :pending, value: 0, incentive: goal.incentive)
      else
        last_daily.update(date: Date.current)
      end
    end
  end
end
