class Daily < ApplicationRecord
  enum status: {
    failed: 1,
    success: 2
  }, _prefix: :status

  belongs_to :goal
  belongs_to :incentive, optional: true

  include WithEnum

  validates :goal, :value, :date, :status, presence: true
end
