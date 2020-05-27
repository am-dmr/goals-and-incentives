require 'rails_helper'

describe FreezeDailies do
  subject { described_class.call(user, force) }

  let(:user) { create(:user) }

  context 'with per day dailies' do
    let(:goal) { create(:goal, user: user, period: :per_day) }

    let!(:today) { create(:daily, goal: goal, date: Date.current, status: :pending) }
    let!(:yesterday) { create(:daily, goal: goal, date: Date.yesterday, status: :pending) }
    let!(:two_days_ago) { create(:daily, goal: goal, date: 2.days.ago.to_date, status: :pending) }
    let!(:success) { create(:daily, goal: goal, date: 2.days.ago.to_date, status: :success) }
    let!(:failed) { create(:daily, goal: goal, date: 2.days.ago.to_date, status: :failed) }

    let!(:per_week) do
      create(:daily,
             goal: create(:goal, user: user, period: :per_week),
             date: Date.current.beginning_of_week,
             status: :pending)
    end

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
      it 'does not RecalcDailyStatus for per_week' do
        expect(RecalcDailyStatus).not_to receive(:call).with(per_week, current_daily: false)
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
      it 'does not RecalcDailyStatus for per_week' do
        expect(RecalcDailyStatus).not_to receive(:call).with(per_week, current_daily: false)
        subject
      end
    end
  end

  context 'with per week dailies' do
    let(:goal) { create(:goal, user: user, period: :per_week) }

    let!(:this_week) do
      create(:daily, goal: goal, date: Date.current.beginning_of_week, status: :pending)
    end
    let!(:prev_week) do
      create(:daily, goal: goal, date: Date.current.beginning_of_week - 7.days, status: :pending)
    end
    let!(:prev_prev_week) do
      create(:daily, goal: goal, date: Date.current.beginning_of_week - 14.days, status: :pending)
    end

    context 'with Monday' do
      around do |example|
        Timecop.freeze(Time.current.beginning_of_week + 12.hours) do
          example.run
        end
      end

      context 'with force = false' do
        let(:force) { false }

        it 'does not RecalcDailyStatus for this_week' do
          expect(RecalcDailyStatus).not_to receive(:call).with(this_week, current_daily: false)
          subject
        end
        it 'does not RecalcDailyStatus for prev_week' do
          expect(RecalcDailyStatus).not_to receive(:call).with(prev_week, current_daily: false)
          subject
        end
        it 'RecalcDailyStatus for prev_prev_week' do
          expect(RecalcDailyStatus).to receive(:call).with(prev_prev_week, current_daily: false)
          subject
        end
      end

      context 'with force = true' do
        let(:force) { true }

        it 'does not RecalcDailyStatus for this_week' do
          expect(RecalcDailyStatus).not_to receive(:call).with(this_week, current_daily: false)
          subject
        end
        # rubocop:disable RSpec/MultipleExpectations
        it 'RecalcDailyStatus for prev_week & prev_prev_week' do
          expect(RecalcDailyStatus).to receive(:call).with(prev_week, current_daily: false)
          expect(RecalcDailyStatus).to receive(:call).with(prev_prev_week, current_daily: false)
          subject
        end
        # rubocop:enable RSpec/MultipleExpectations
      end
    end

    context 'with Tuesday' do
      around do |example|
        Timecop.freeze(Time.current.beginning_of_week + 36.hours) do
          example.run
        end
      end

      context 'with force = false' do
        let(:force) { false }

        it 'does not RecalcDailyStatus for this_week' do
          expect(RecalcDailyStatus).not_to receive(:call).with(this_week, current_daily: false)
          subject
        end
        # rubocop:disable RSpec/MultipleExpectations
        it 'RecalcDailyStatus for prev_week & prev_prev_week' do
          expect(RecalcDailyStatus).to receive(:call).with(prev_week, current_daily: false)
          expect(RecalcDailyStatus).to receive(:call).with(prev_prev_week, current_daily: false)
          subject
        end
        # rubocop:enable RSpec/MultipleExpectations
      end

      context 'with force = true' do
        let(:force) { true }

        it 'does not RecalcDailyStatus for this_week' do
          expect(RecalcDailyStatus).not_to receive(:call).with(this_week, current_daily: false)
          subject
        end
        # rubocop:disable RSpec/MultipleExpectations
        it 'RecalcDailyStatus for prev_week & prev_prev_week' do
          expect(RecalcDailyStatus).to receive(:call).with(prev_week, current_daily: false)
          expect(RecalcDailyStatus).to receive(:call).with(prev_prev_week, current_daily: false)
          subject
        end
        # rubocop:enable RSpec/MultipleExpectations
      end
    end

    context 'with Sunday' do
      around do |example|
        Timecop.freeze(Time.current.end_of_week - 12.hours) do
          example.run
        end
      end

      context 'with force = false' do
        let(:force) { false }

        it 'does not RecalcDailyStatus for this_week' do
          expect(RecalcDailyStatus).not_to receive(:call).with(this_week, current_daily: false)
          subject
        end
        # rubocop:disable RSpec/MultipleExpectations
        it 'RecalcDailyStatus for prev_week & prev_prev_week' do
          expect(RecalcDailyStatus).to receive(:call).with(prev_week, current_daily: false)
          expect(RecalcDailyStatus).to receive(:call).with(prev_prev_week, current_daily: false)
          subject
        end
        # rubocop:enable RSpec/MultipleExpectations
      end

      context 'with force = true' do
        let(:force) { true }

        it 'does not RecalcDailyStatus for this_week' do
          expect(RecalcDailyStatus).not_to receive(:call).with(this_week, current_daily: false)
          subject
        end
        # rubocop:disable RSpec/MultipleExpectations
        it 'RecalcDailyStatus for prev_week & prev_prev_week' do
          expect(RecalcDailyStatus).to receive(:call).with(prev_week, current_daily: false)
          expect(RecalcDailyStatus).to receive(:call).with(prev_prev_week, current_daily: false)
          subject
        end
        # rubocop:enable RSpec/MultipleExpectations
      end
    end
  end
end
