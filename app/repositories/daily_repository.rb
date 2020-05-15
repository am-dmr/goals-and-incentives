class DailyRepository < BaseRepository
  def per_day_dailies(user)
    return Daily.none unless user

    user
      .dailies
      .where(date: Date.current)
      .joins(:goal)
      .merge(Goal.period_per_day)
      .includes(:goal, :incentive)
      .order('goals.size ASC')
  end

  def per_week_dailies(user)
    return Daily.none unless user

    user
      .dailies
      .where(date: Date.current.beginning_of_week)
      .joins(:goal)
      .merge(Goal.period_per_week)
      .includes(:goal, :incentive)
      .order('goals.size ASC')
  end

  def once_dailies(user)
    return Daily.none unless user

    user
      .dailies
      .where(date: Date.current)
      .joins(:goal)
      .merge(Goal.period_once)
      .includes(:goal, :incentive)
      .order('goals.size ASC')
  end
end
