FactoryBot.define do
  factory :goal do
    user { create(:user) }
    sequence(:name) { |n| "Goal #{n}" }
    limit { 1 }
    aim { :equal }
    period { :once }
    size { :l }
  end
end
