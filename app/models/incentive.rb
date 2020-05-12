class Incentive < ApplicationRecord
  belongs_to :user

  include WithSize

  validates :user, :name, presence: true
end
