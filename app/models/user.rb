class User < ApplicationRecord
  devise :database_authenticatable, :rememberable

  validates :email, presence: true, uniqueness: true
  validates :username, presence: true, uniqueness: true
end
