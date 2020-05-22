require 'rails_helper'

describe GenerateDailies do
  subject { described_class.call(user) }

  let(:user) { create(:user) }
  let(:incentive) { create(:incentive, user: user) }

  shared_examples 'create new daily' do
    it 'creates new daily' do
      expect { subject }.to change { Daily.count }.by(1)
    end
    it 'creates correct daily' do
      subject
      expect(Daily.last).to have_attributes(
        goal_id: goal.id,
        status: 'pending',
        value: 0,
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
    let!(:goal) { create(:goal, user: user, period: :per_day, incentive: incentive) }

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
    let!(:goal) { create(:goal, user: user, period: :per_day, incentive: incentive) }

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

  context 'with once goal' do
    context 'with incompleted goal' do
      let!(:goal) { create(:goal, user: user, period: :once, is_completed: false, incentive: incentive) }

      context 'with success daily' do
        before { create(:daily, goal: goal, status: :success, date: Date.yesterday) }

        it_behaves_like('create new daily')
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

    context 'with completed goal' do
      let!(:goal) { create(:goal, user: user, period: :once, is_completed: true, incentive: incentive) }

      context 'with success daily' do
        before { create(:daily, goal: goal, status: :success, date: Date.yesterday) }

        it_behaves_like('do nothing')
      end

      context 'with pending daily' do
        let!(:daily) { create(:daily, goal: goal, status: :pending, date: Date.yesterday) }

        it_behaves_like('do nothing')

        it 'does not change old daily' do
          expect { subject }.not_to(change { daily.reload })
        end
      end
    end
  end
end
