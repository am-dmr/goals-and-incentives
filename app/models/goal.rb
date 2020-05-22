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

  has_many :dailies, dependent: :restrict_with_error

  include WithSize
  include WithEnum

  validates :user, :name, :limit, :aim, :period, presence: true

  validate :once_aim_and_limit, if: :period_once?

  private

  def once_aim_and_limit
    errors.add(:limit, :for_once_only_one) unless limit == 1
    errors.add(:aim, :for_once_only_equal) unless aim_equal?
  end
end
