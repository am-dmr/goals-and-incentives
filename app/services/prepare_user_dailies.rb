class PrepareUserDailies < BaseService
  param :user

  def call
    return unless user
    return if user.last_visited_at&.today?

    DropOldDailies.call(user)
    GenerateDailies.call(user)
    FreezeDailies.call(user)
  end
end
