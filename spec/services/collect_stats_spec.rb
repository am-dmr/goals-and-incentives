require 'rails_helper'

describe CollectStats do
  subject { described_class.call(relation) }

  let(:user) { create(:user) }

  let(:once) { create(:goal, user: user, period: :once, size: :xxl) }
  let(:per_day_xl) { create(:goal, user: user, period: :per_day, size: :xl) }
  let(:per_day_xs) { create(:goal, user: user, period: :per_day, size: :xs) }
  let(:per_week) { create(:goal, user: user, period: :per_week, size: :m) }

  let(:relation) { Daily.all }

  before do
    create(:daily, goal: once, date: Date.current, status: :pending, incentive_status: :none)
    create(:daily, goal: per_day_xl, date: Date.yesterday, status: :pending, incentive_status: :none)
    create(:daily, goal: per_day_xl, date: 2.days.ago.to_date, status: :failed, incentive_status: :none)
    create(:daily, goal: per_day_xs, date: 2.days.ago.to_date, status: :success, incentive_status: :success)
    create(:daily, goal: per_week, date: 8.days.ago.beginning_of_week, status: :success, incentive_status: :failed)
  end

  it 'returns correct stats' do
    expect(subject).to eq(
      {
        once.id => {
          name: once.name,
          period: 'once',
          Date.current.strftime('%d%m') => { status: 'pending', incentive_status: 'none' }
        },
        per_day_xl.id => {
          name: per_day_xl.name,
          period: 'per_day',
          Date.yesterday.strftime('%d%m') => { status: 'pending', incentive_status: 'none' },
          2.days.ago.to_date.strftime('%d%m') => { status: 'failed', incentive_status: 'none' }
        },
        per_day_xs.id => {
          name: per_day_xs.name,
          period: 'per_day',
          2.days.ago.to_date.strftime('%d%m') => { status: 'success', incentive_status: 'success' }
        },
        per_week.id => {
          name: per_week.name,
          period: 'per_week',
          8.days.ago.beginning_of_week.strftime('%d%m') => { status: 'success', incentive_status: 'failed' },
          (8.days.ago.beginning_of_week + 1.day).strftime('%d%m') => { status: 'success', incentive_status: 'failed' },
          (8.days.ago.beginning_of_week + 2.days).strftime('%d%m') => { status: 'success', incentive_status: 'failed' },
          (8.days.ago.beginning_of_week + 3.days).strftime('%d%m') => { status: 'success', incentive_status: 'failed' },
          (8.days.ago.beginning_of_week + 4.days).strftime('%d%m') => { status: 'success', incentive_status: 'failed' },
          (8.days.ago.beginning_of_week + 5.days).strftime('%d%m') => { status: 'success', incentive_status: 'failed' },
          (8.days.ago.beginning_of_week + 6.days).strftime('%d%m') => { status: 'success', incentive_status: 'failed' }
        }
      }
    )
  end
end
