require 'rails_helper'

describe AutoReactivateGoals do
  subject { described_class.call(user) }

  let(:user) { create(:user) }

  shared_examples 'do nothing' do
    it 'does not update Goal.is_completed' do
      expect { subject }.not_to(change { goal.reload.is_completed })
    end
    it 'does not call GenerateDaily' do
      expect(GenerateDaily).not_to receive(:call)
      subject
    end
  end

  shared_examples 'do reactivation' do
    it 'updates Goal.is_completed' do
      expect { subject }.to change { goal.reload.is_completed }.to(false)
    end
    it 'calls GenerateDaily' do
      expect(GenerateDaily).to receive(:call).with(goal)
      subject
    end
  end

  # rubocop:disable RSpec/LetSetup
  context 'with per day' do
    let!(:goal) do
      create(:goal,
             user: user,
             period: :per_day,
             is_completed: true,
             auto_reactivate_start_from: 9.days.ago)
    end

    it_behaves_like('do nothing')
  end
  # rubocop:enable RSpec/LetSetup

  # rubocop:disable RSpec/LetSetup
  context 'with per week' do
    let!(:goal) do
      create(:goal,
             user: user,
             period: :per_week,
             is_completed: true,
             auto_reactivate_start_from: 9.days.ago)
    end

    it_behaves_like('do nothing')
  end
  # rubocop:enable RSpec/LetSetup

  context 'with once' do
    let!(:goal) do
      create(:goal,
             user: user,
             period: :once,
             is_completed: true,
             auto_reactivate_every_n_days: 2,
             auto_reactivate_start_from: 9.days.ago.to_date)
    end

    context 'without dailies' do
      it_behaves_like('do reactivation')
    end

    context 'with old daily' do
      before { create(:daily, goal: goal, date: 2.days.ago.to_date) }

      it_behaves_like('do reactivation')
    end

    context 'with new daily' do
      before { create(:daily, goal: goal, date: 1.day.ago.to_date) }

      it_behaves_like('do nothing')
    end

    context 'with not completed' do
      before { goal.update(is_completed: false) }

      it_behaves_like('do nothing')
    end

    context 'without auto_reactivate_every_n_days' do
      before { goal.update(auto_reactivate_every_n_days: nil) }

      it_behaves_like('do nothing')
    end

    context "with another's goal" do
      before { goal.update(user: create(:user)) }

      it_behaves_like('do nothing')
    end
  end

  context 'with once + per week' do
    let!(:goal) do
      create(:goal,
             user: user,
             period: :once,
             is_completed: true,
             auto_reactivate_every_n_days: 7,
             auto_reactivate_start_from: 7.days.ago.to_date)
    end

    context 'with old daily' do
      before { create(:daily, goal: goal, date: 6.days.ago.to_date) }

      it_behaves_like('do reactivation')
    end
  end
end
