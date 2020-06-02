require 'rails_helper'

describe GenerateDaily do
  subject { described_class.call(goal) }

  let(:user) { create(:user) }
  let(:incentive) { create(:incentive, user: user) }

  shared_examples 'create new daily' do |date|
    it 'creates new daily' do
      expect { subject }.to change { Daily.count }.by(1)
    end
    it 'creates correct daily' do
      subject
      expect(Daily.last).to have_attributes(
        goal_id: goal.id,
        status: 'pending',
        value: 0,
        date: date,
        incentive_id: incentive.id
      )
    end
  end

  shared_examples 'do nothing' do
    it 'does not create new daily' do
      expect { subject }.not_to(change { Daily.count })
    end
  end

  context 'with per day goal' do
    let(:goal) { create(:goal, user: user, period: :per_day, incentive: incentive) }

    it_behaves_like('create new daily', Date.current)
  end

  context 'with per week goal' do
    let(:goal) { create(:goal, user: user, period: :per_week, incentive: incentive) }

    it_behaves_like('create new daily', Date.current.beginning_of_week)
  end

  context 'with once goal' do
    let(:goal) { create(:goal, user: user, period: :once, incentive: incentive) }

    context 'without daily' do
      it_behaves_like('create new daily', Date.current)
    end

    context 'with success daily' do
      before { create(:daily, goal: goal, status: :success, date: Date.yesterday) }

      it_behaves_like('create new daily', Date.current)
    end

    context 'with pending daily' do
      let!(:daily) { create(:daily, goal: goal, status: :pending, date: Date.yesterday) }

      it_behaves_like('do nothing')

      it 'moves old daily to today' do
        expect { subject }.to change { daily.reload.date }.to(Date.current)
      end
      it 'does not update old daily status' do
        expect { subject }.not_to(change { daily.reload.status })
      end
    end
  end
end
