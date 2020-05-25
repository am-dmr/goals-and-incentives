require 'rails_helper'

describe FreezeDailies do
  subject { described_class.call(user, force) }

  let(:user) { create(:user) }
  let(:goal) { create(:goal, user: user) }

  let!(:today) { create(:daily, goal: goal, date: Date.current, status: :pending) }
  let!(:yesterday) { create(:daily, goal: goal, date: Date.yesterday, status: :pending) }
  let!(:two_days_ago) { create(:daily, goal: goal, date: 2.days.ago.to_date, status: :pending) }
  let!(:success) { create(:daily, goal: goal, date: 2.days.ago.to_date, status: :success) }
  let!(:failed) { create(:daily, goal: goal, date: 2.days.ago.to_date, status: :failed) }

  context 'with force = false' do
    let(:force) { false }

    it 'does not RecalcDailyStatus for today' do
      expect(RecalcDailyStatus).not_to receive(:call).with(today, current_daily: false)
      subject
    end
    it 'does not RecalcDailyStatus for yesterday' do
      expect(RecalcDailyStatus).not_to receive(:call).with(yesterday, current_daily: false)
      subject
    end
    it 'RecalcDailyStatus for two_days_ago' do
      expect(RecalcDailyStatus).to receive(:call).with(two_days_ago, current_daily: false)
      subject
    end
    it 'does not RecalcDailyStatus for success' do
      expect(RecalcDailyStatus).not_to receive(:call).with(success, current_daily: false)
      subject
    end
    it 'does not RecalcDailyStatus for failed' do
      expect(RecalcDailyStatus).not_to receive(:call).with(failed, current_daily: false)
      subject
    end
  end

  context 'with force = true' do
    let(:force) { true }

    it 'does not RecalcDailyStatus for today' do
      expect(RecalcDailyStatus).not_to receive(:call).with(today, current_daily: false)
      subject
    end
    # rubocop:disable RSpec/MultipleExpectations
    it 'RecalcDailyStatus for yesterday & two_days_ago' do
      expect(RecalcDailyStatus).to receive(:call).with(yesterday, current_daily: false)
      expect(RecalcDailyStatus).to receive(:call).with(two_days_ago, current_daily: false)
      subject
    end
    # rubocop:enable RSpec/MultipleExpectations
    it 'does not RecalcDailyStatus for success' do
      expect(RecalcDailyStatus).not_to receive(:call).with(success, current_daily: false)
      subject
    end
    it 'does not RecalcDailyStatus for failed' do
      expect(RecalcDailyStatus).not_to receive(:call).with(failed, current_daily: false)
      subject
    end
  end
end
