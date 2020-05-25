class FreezeDailies < BaseService
  param :user
  param :force, default: -> { false }

  def call
    return unless user

    date_to = force ? Date.current : Date.yesterday
    user.dailies.status_pending.where('date < ?', date_to).find_each do |daily|
      RecalcDailyStatus.call(daily, current_daily: false)
    end
  end
end
