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

  include WithSize
  include WithEnum

  validates :user, :name, :limit, :aim, :period, presence: true
end
