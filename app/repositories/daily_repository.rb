class DailyRepository < BaseRepository
  def current_day(user)
    return Daily.none unless user

    user
      .dailies
      .joins(:goal)
      .includes(:goal, :incentive)
      .where(<<~SQL)
        (
          dailies.date = '#{Date.current}' AND
          (goals.period = #{Goal.periods[:once]} OR goals.period = #{Goal.periods[:per_day]})
        ) OR (
          dailies.date = '#{Date.current.beginning_of_week}' AND
          goals.period = #{Goal.periods[:per_week]}
        )
      SQL
      .order(
        Arel.sql(<<~SQL)
          goals.period = #{Goal.periods[:per_day]} DESC,
          goals.period = #{Goal.periods[:per_week]} DESC,
          goals.size DESC
        SQL
      )
  end

  def stats(user)
    return Daily.none unless user

    user
      .dailies
      .where(date: (21.days.ago..))
      .includes(:goal)
      .order(
        Arel.sql(<<~SQL)
          goals.period = #{Goal.periods[:per_day]} DESC,
          goals.period = #{Goal.periods[:per_week]} DESC,
          goals.size DESC,
          dailies.date ASC
        SQL
      )
  end
end
