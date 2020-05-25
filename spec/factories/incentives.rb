FactoryBot.define do
  factory :incentive do
    user { create(:user) }
    sequence(:name) { |n| "Incentive #{n}" }
    size { :l }
  end
end
