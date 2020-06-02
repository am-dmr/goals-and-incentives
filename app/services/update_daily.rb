class UpdateDaily < BaseService
  param :daily
  param :action

  option :value, optional: true

  def call
    case action
    when :increment
      daily.update(value: daily.value + 1)
    when :decrement
      daily.update(value: daily.value - 1)
    when :set_value
      daily.update(value: value)
    end

    RecalcDailyStatus.call(daily, current_daily: daily.date == Date.current)
  end
end
