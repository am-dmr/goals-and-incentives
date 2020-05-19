class Daily < ApplicationRecord
  enum status: {
    pending: 1,
    success: 2,
    failed: 3
  }, _prefix: :status

  belongs_to :goal
  belongs_to :incentive, optional: true

  include WithEnum

  validates :goal, :value, :date, :status, presence: true
end
