class GenerateDailies < BaseService
  param :user

  def call
    return unless user

    generate_per_day_dailies
    generate_per_week_dailies
    move_once_dailies
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
      goal.dailies.create(date: Date.current, status: :pending, value: 0)
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
      goal.dailies.create(date: Date.current.beginning_of_week, status: :pending, value: 0)
    end
  end

  def move_once_dailies; end
end
