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

  enum size: {
    xs: 1,
    s: 2,
    m: 3,
    l: 4,
    xl: 5,
    xxl: 6,
    xxxl: 7
  }, _prefix: :size

  belongs_to :user

  validates :user, :name, :limit, :aim, :period, :size, presence: true
end
