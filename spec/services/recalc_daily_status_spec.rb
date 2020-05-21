require 'rails_helper'

describe RecalcDailyStatus do
  subject { described_class.call(daily, current_daily: current_daily) }

  let(:current_daily) { true }

  shared_examples 'regular' do
    shared_examples 'success case' do
      it 'sets status to success' do
        expect { subject }.to change { daily.reload.status }.to('success')
      end
      it 'does not update goal' do
        expect { subject }.not_to(change { goal.reload.is_completed })
      end
    end

    shared_examples 'failed case' do
      context 'with current daily' do
        let(:current_daily) { true }

        it 'sets status to pending' do
          expect { subject }.not_to(change { daily.reload.status })
        end
        it 'does not update goal' do
          expect { subject }.not_to(change { goal.reload.is_completed })
        end
      end

      context 'without current daily' do
        let(:current_daily) { false }

        it 'sets status to failed' do
          expect { subject }.to change { daily.reload.status }.to('failed')
        end
        it 'does not update goal' do
          expect { subject }.not_to(change { goal.reload.is_completed })
        end
      end
    end

    context 'with less than aim' do
      before { goal.update(aim: :less_than) }

      context 'with less than' do
        before { daily.update(value: 1) }

        it_behaves_like('success case')
      end

      context 'with equal' do
        before { daily.update(value: 2) }

        it_behaves_like('failed case')
      end

      context 'with greater than' do
        before { daily.update(value: 3) }

        it_behaves_like('failed case')
      end
    end

    context 'with equal aim' do
      before { goal.update(aim: :equal) }

      context 'with less than' do
        before { daily.update(value: 1) }

        it_behaves_like('failed case')
      end

      context 'with equal' do
        before { daily.update(value: 2) }

        it_behaves_like('success case')
      end

      context 'with greater than' do
        before { daily.update(value: 3) }

        it_behaves_like('failed case')
      end
    end

    context 'with greater than aim' do
      before { goal.update(aim: :greater_than) }

      context 'with less than' do
        before { daily.update(value: 1) }

        it_behaves_like('failed case')
      end

      context 'with equal' do
        before { daily.update(value: 2) }

        it_behaves_like('failed case')
      end

      context 'with greater than' do
        before { daily.update(value: 3) }

        it_behaves_like('success case')
      end
    end
  end

  context 'with per day goal' do
    let(:goal) { create(:goal, period: :per_day, limit: 2) }
    let(:daily) { create(:daily, goal: goal, value: 2, status: :pending) }

    it_behaves_like('regular')
  end

  context 'with per week goal' do
    let(:goal) { create(:goal, period: :per_week, limit: 2) }
    let(:daily) { create(:daily, goal: goal, value: 2, status: :pending) }

    it_behaves_like('regular')
  end

  context 'with once goal' do
    let(:goal) { create(:goal, period: :once, limit: 1) }
    let(:daily) { create(:daily, goal: goal, value: 1, status: :pending) }

    shared_examples 'success case' do
      it 'sets status to success' do
        expect { subject }.to change { daily.reload.status }.to('success')
      end
      it 'updates goal' do
        expect { subject }.to change { goal.reload.is_completed }.to(true)
      end
    end

    shared_examples 'failed case' do
      context 'with current daily' do
        let(:current_daily) { true }

        it 'sets status to pending' do
          expect { subject }.not_to(change { daily.reload.status })
        end
        it 'does not update goal' do
          expect { subject }.not_to(change { goal.reload.is_completed })
        end
      end

      context 'without current daily' do
        let(:current_daily) { false }

        it 'sets status to failed' do
          expect { subject }.to change { daily.reload.status }.to('failed')
        end
        it 'does not update goal' do
          expect { subject }.not_to(change { goal.reload.is_completed })
        end
      end
    end

    context 'with equal aim' do
      before { goal.update(aim: :equal) }

      context 'with less than' do
        before { daily.update(value: 0) }

        it_behaves_like('failed case')
      end

      context 'with equal' do
        before { daily.update(value: 1) }

        it_behaves_like('success case')
      end

      context 'with greater than' do
        before { daily.update(value: 2) }

        it_behaves_like('failed case')
      end
    end
  end
end
