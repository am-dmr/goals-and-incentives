class GenerateDaily < BaseService
  param :goal

  def call
    case goal.period
    when 'per_day'
      create_or_update_daily(Date.current)
    when 'per_week'
      create_or_update_daily(Date.current.beginning_of_week)
    when 'once'
      last_daily = goal.dailies.last
      if !last_daily || last_daily.status_success?
        create_daily(Date.current)
      else
        last_daily.update(date: Date.current)
      end
    end
  end

  private

  def create_or_update_daily(date)
    daily = goal.dailies.find_by(date: date)

    if daily
      daily.update(status: :pending, incentive: goal.incentive, incentive_status: :none)
    else
      create_daily(date)
    end
  end

  def create_daily(date)
    goal.dailies.create(date: date, status: :pending, value: 0, incentive: goal.incentive, incentive_status: :none)
  end
end
