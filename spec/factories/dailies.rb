FactoryBot.define do
  factory :daily do
    goal { create(:goal) }
    value { 0 }
    date { Date.current }
    status { :failed }
  end
end
