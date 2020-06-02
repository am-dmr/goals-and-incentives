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
      GenerateDaily.call(goal)
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
      GenerateDaily.call(goal)
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
      GenerateDaily.call(goal)
    end
  end
end
