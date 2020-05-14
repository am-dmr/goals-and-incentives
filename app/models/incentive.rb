class Incentive < ApplicationRecord
  belongs_to :user

  include WithSize
  include WithEnum

  validates :user, :name, presence: true
end
