require 'rails_helper'

describe DailyRepository do
  describe '#current_day' do
    subject { described_class.new.current_day(user) }

    let(:user) { create(:user) }

    let(:once) { create(:goal, user: user, period: :once, size: :xxl) }
    let(:per_day_xl) { create(:goal, user: user, period: :per_day, size: :xl) }
    let(:per_day_xs) { create(:goal, user: user, period: :per_day, size: :xs) }
    let(:per_week) { create(:goal, user: user, period: :per_week, size: :m) }

    let!(:dailies) do
      [
        create(:daily, goal: once, date: Date.current),
        create(:daily, goal: per_day_xl, date: Date.current),
        create(:daily, goal: per_day_xl, date: Date.yesterday),
        create(:daily, goal: per_day_xs, date: Date.current),
        create(:daily, goal: per_day_xs, date: Date.yesterday),
        create(:daily, goal: per_week, date: Date.current.beginning_of_week),
        create(:daily, goal: create(:goal), date: Date.current)
      ]
    end

    context 'without user' do
      subject { described_class.new.current_day(nil) }

      it 'returns empty relation' do
        expect(subject).to be_empty
      end
    end

    it 'returns correct dailies in correct order' do
      expect(subject.pluck(:id)).to eq([dailies[1].id, dailies[3].id, dailies[5].id, dailies[0].id])
    end
  end
end
