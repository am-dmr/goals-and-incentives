class User < ApplicationRecord
  devise :database_authenticatable, :rememberable

  has_many :goals
  has_many :incentives

  validates :email, presence: true, uniqueness: true
  validates :username, presence: true, uniqueness: true
end
