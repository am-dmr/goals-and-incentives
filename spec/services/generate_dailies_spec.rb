require 'rails_helper'

describe GenerateDailies do
  subject { described_class.call(user) }

  let(:user) { create(:user) }

  shared_examples 'create new daily' do
    it 'creates new daily' do
      expect { subject }.to change { Daily.count }.by(1)
    end
    it 'creates correct daily' do
      subject
      expect(Daily.last).to have_attributes(
        goal_id: goal.id,
        status: 'pending',
        value: 0
      )
    end
  end

  shared_examples 'do nothing' do
    it 'does not create new daily' do
      expect { subject }.not_to(change { Daily.count })
    end
  end

  context 'with per day goal' do
    let!(:goal) { create(:goal, user: user, period: :per_day) }

    before { create(:daily, goal: goal, date: Date.yesterday) }

    it_behaves_like('create new daily')

    context 'with today daily' do
      before { create(:daily, goal: goal, date: Date.current) }

      it_behaves_like('do nothing')
    end

    context 'with incorrect user' do
      before { goal.update(user: create(:user)) }

      it_behaves_like('do nothing')
    end
  end

  context 'with per week goal' do
    let!(:goal) { create(:goal, user: user, period: :per_day) }

    before { create(:daily, goal: goal, date: 14.days.ago.to_date) }

    it_behaves_like('create new daily')

    context 'with existed week daily' do
      before { create(:daily, goal: goal, date: Date.current.beginning_of_day) }

      it_behaves_like('do nothing')
    end

    context 'with incorrect user' do
      before { goal.update(user: create(:user)) }

      it_behaves_like('do nothing')
    end
  end
end
