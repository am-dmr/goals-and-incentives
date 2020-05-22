class Daily < ApplicationRecord
  enum status: {
    pending: 1,
    success: 2,
    failed: 3
  }, _prefix: :status

  enum incentive_status: {
    none: 1,
    success: 2,
    failed: 3
  }, _prefix: :incentive_status

  belongs_to :goal
  belongs_to :incentive, optional: true

  include WithEnum

  validates :goal, :value, :date, :status, :incentive_status, presence: true

  before_validation(on: :create) do
    self.value ||= 0
    self.date ||= Date.current
    self.status ||= :pending
    self.incentive_status ||= :none
  end
end
