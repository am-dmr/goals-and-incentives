class User < ApplicationRecord
  devise :database_authenticatable, :rememberable

  has_many :goals, dependent: :restrict_with_error
  has_many :incentives, dependent: :restrict_with_error
  has_many :dailies, through: :goals

  validates :email, presence: true, uniqueness: true
  validates :username, presence: true, uniqueness: true
end
