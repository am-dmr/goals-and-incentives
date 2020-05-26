class FreezeDailies < BaseService
  param :user
  param :force, default: -> { false }

  def call
    return unless user

    user
      .dailies
      .status_pending
      .joins(:goal)
      .where(<<~SQL)
        (
          dailies.date < '#{date_to_day}' AND
          (goals.period = #{Goal.periods[:once]} OR goals.period = #{Goal.periods[:per_day]})
        ) OR (
          dailies.date < '#{date_to_week}' AND
          goals.period = #{Goal.periods[:per_week]}
        )
      SQL
      .find_each do |daily|
      RecalcDailyStatus.call(daily, current_daily: false)
    end
  end

  private

  def date_to_day
    @date_to_day ||= force ? Date.current : Date.yesterday
  end

  def date_to_week
    @date_to_week ||= force ? (Date.current.beginning_of_week - 1.day) : 1.week.ago.to_date
  end
end
