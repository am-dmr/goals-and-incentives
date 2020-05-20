class RecalcDailyStatus < BaseService
  param :daily

  option :current_daily

  def call
    status = status_by_aim || (current_daily ? :pending : :failed)
    daily.update(status: status)
    daily.goal.update(is_completed: status == :success) if daily.goal.period_once?
  end

  private

  def status_by_aim
    case daily.goal.aim
    when 'less_than'
      :success if daily.value < daily.goal.limit
    when 'equal'
      :success if daily.value == daily.goal.limit
    when 'greater_than'
      :success if daily.value > daily.goal.limit
    end
  end
end
