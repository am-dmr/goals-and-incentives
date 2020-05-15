class Incentive < ApplicationRecord
  belongs_to :user

  has_many :dailies, dependent: :restrict_with_error

  include WithSize
  include WithEnum

  validates :user, :name, presence: true
end
