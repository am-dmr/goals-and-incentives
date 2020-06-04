class Goal < ApplicationRecord
  enum aim: {
    less_than: 1,
    equal: 2,
    greater_than: 3
  }, _prefix: :aim

  enum period: {
    once: 1,
    per_day: 2,
    per_week: 3
  }, _prefix: :period

  belongs_to :user
  belongs_to :incentive, optional: true

  has_many :dailies, dependent: :destroy

  include WithSize
  include WithEnum

  validates :user, :name, :limit, :aim, :period, presence: true
  validates :auto_reactivate_every_n_days, numericality: { only_integer: true, greater_than: 1 }, allow_nil: true

  validate :auto_reactivation

  before_validation(on: :create) do
    self.limit ||= 1
    self.is_completed ||= false
  end

  private

  def auto_reactivation
    errors.add(:auto_reactivate_every_n_days, :for_once_only) if auto_reactivate_every_n_days.present? && !period_once?
    return if auto_reactivate_start_from.present? || auto_reactivate_every_n_days.blank?

    errors.add(:auto_reactivate_start_from, :blank)
  end
end
