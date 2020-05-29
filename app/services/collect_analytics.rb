class CollectAnalytics < BaseService
  param :user

  def call
    return {} unless user

    stats = { weekly: {}, daily: {} }

    fill_daily_success_rate(stats)
    fill_weekly_success_rate(stats)

    stats
  end

  private

  def this_week
    @this_week ||= (Date.current.beginning_of_week..Date.current.end_of_week)
  end

  def prev_week
    @prev_week ||= (7.days.ago.to_date.beginning_of_week..7.days.ago.to_date.end_of_week)
  end

  def prev_prev_week
    @prev_prev_week ||= (14.days.ago.to_date.beginning_of_week..14.days.ago.to_date.end_of_week)
  end

  def fill_daily_success_rate(stats)
    daily_relation = user.dailies.joins(:goal).merge(Goal.period_per_day)
    stats[:daily] = {
      this_week: daily_relation.where(date: this_week).group(:status).count,
      prev_week: daily_relation.where(date: prev_week).group(:status).count,
      prev_prev_week: daily_relation.where(date: prev_prev_week).group(:status).count
    }
  end

  def fill_weekly_success_rate(stats)
    weekly_relation = user.dailies.joins(:goal).merge(Goal.period_per_week)
    stats[:weekly] = {
      this_week: weekly_relation.where(date: this_week).group(:status).count,
      prev_week: weekly_relation.where(date: prev_week).group(:status).count,
      prev_prev_week: weekly_relation.where(date: prev_prev_week).group(:status).count
    }
  end
end
