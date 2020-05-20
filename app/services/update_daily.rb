class UpdateDaily < BaseService
  param :daily
  param :action

  def call
    case action
    when :increment
      daily.update(value: daily.value + 1)
    when :decrement
      daily.update(value: daily.value - 1)
    end

    RecalcDailyStatus.call(daily, current_daily: true)
  end
end
