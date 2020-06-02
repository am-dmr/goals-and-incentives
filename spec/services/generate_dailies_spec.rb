require 'rails_helper'

describe GenerateDailies do
  subject { described_class.call(user) }

  let(:user) { create(:user) }
  let(:incentive) { create(:incentive, user: user) }

  shared_examples 'do call' do
    it 'calls GenerateDaily' do
      expect(GenerateDaily).to receive(:call).with(goal)
      subject
    end
  end

  shared_examples 'do nothing' do
    it 'does not call GenerateDaily' do
      expect(GenerateDaily).not_to receive(:call)
      subject
    end
  end

  context 'with per day goal' do
    let!(:goal) { create(:goal, user: user, period: :per_day, incentive: incentive) }

    before { create(:daily, goal: goal, date: Date.yesterday) }

    it_behaves_like('do call')

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

    it_behaves_like('do call')

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

      it_behaves_like('do call')

      context 'with today daily' do
        before { create(:daily, goal: goal, date: Date.current) }

        it_behaves_like('do nothing')
      end

      context 'with incorrect user' do
        before { goal.update(user: create(:user)) }

        it_behaves_like('do nothing')
      end
    end

    context 'with completed goal' do
      before { create(:goal, user: user, period: :once, is_completed: true, incentive: incentive) }

      it_behaves_like('do nothing')
    end
  end
end
