class DropOldDailies < BaseService
  param :user

  def call
    return unless user

    user.dailies.where('date < ?', 20.days.ago.to_date).destroy_all
  end
end
