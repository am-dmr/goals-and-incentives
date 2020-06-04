require 'rails_helper'

describe Web::V1::GoalsController do
  let(:user) { create(:user) }
  let(:incentive) { create(:incentive, user: user) }

  describe '#create' do
    subject { post '/web/1.0/goals', params: params }

    let(:params) do
      { goal: { name: 'Name', aim: 'equal', limit: 3, period: :per_day, size: 'm', incentive: incentive.id } }
    end

    shared_examples 'do nothing' do |code|
      it "returns #{code}" do
        subject
        expect(response).to have_http_status(code)
      end
      it 'does not create Goal' do
        expect { subject }.not_to(change { Goal.count })
      end
      it 'does not call GenerateDaily' do
        expect(GenerateDaily).not_to receive(:call)
        subject
      end
    end

    context 'without current user' do
      it_behaves_like('do nothing', 401)
    end

    context 'with current user' do
      before { sign_in(user) }

      context 'without params' do
        let(:params) {}

        it_behaves_like('do nothing', 400)
      end

      context 'with error' do
        let(:params) do
          { goal: { aim: 'equal', limit: 3, period: :once, size: 'm' } }
        end

        it 'does not create Goal' do
          expect { subject }.not_to(change { Goal.count })
        end
        it 'does not call GenerateDaily' do
          expect(GenerateDaily).not_to receive(:call)
          subject
        end
      end

      context 'with success' do
        it 'creates Goal' do
          expect { subject }.to change { Goal.count }.by(1)
        end
        it 'creates correct Goal' do
          subject
          expect(Goal.last).to have_attributes(
            user_id: user.id,
            name: 'Name',
            limit: 3,
            aim: 'equal',
            period: 'per_day',
            size: 'm',
            incentive_id: incentive.id,
            is_completed: false
          )
        end
        it 'calls GenerateDaily' do
          expect(GenerateDaily).to receive(:call)
          subject
        end
      end

      context 'with once' do
        let(:params) do
          {
            goal: {
              name: 'Name',
              aim: 'equal',
              limit: 1,
              period: :once,
              size: 'm',
              incentive: incentive.id,
              auto_reactivate_every_n_days: 3,
              auto_reactivate_start_from: Date.current.strftime('%d.%m.%Y')
            }
          }
        end

        it 'creates Goal' do
          expect { subject }.to change { Goal.count }.by(1)
        end
        it 'creates correct Goal' do
          subject
          expect(Goal.last).to have_attributes(
            user_id: user.id,
            name: 'Name',
            limit: 1,
            aim: 'equal',
            period: 'once',
            size: 'm',
            incentive_id: incentive.id,
            is_completed: false,
            auto_reactivate_every_n_days: 3,
            auto_reactivate_start_from: Date.current
          )
        end
        it 'calls GenerateDaily' do
          expect(GenerateDaily).to receive(:call)
          subject
        end
      end
    end
  end

  describe '#update' do
    subject { put "/web/1.0/goals/#{goal.id}", params: params }

    let(:goal) { create(:goal, user: user, name: 'ameN', aim: 'less_than', limit: 2, period: :per_week, size: 'l') }

    let(:params) do
      { goal: { name: 'Name', aim: 'equal', limit: 3, period: :per_day, size: 'm', incentive: incentive.id } }
    end

    shared_examples 'do nothing' do |code|
      it "returns #{code}" do
        subject
        expect(response).to have_http_status(code)
      end
      it 'does not update Goal' do
        expect { subject }.not_to(change { goal.reload })
      end
      it 'does not call GenerateDaily' do
        expect(GenerateDaily).not_to receive(:call)
        subject
      end
    end

    context 'without current user' do
      it_behaves_like('do nothing', 401)
    end

    context 'with current user' do
      before { sign_in(user) }

      context 'without params' do
        let(:params) {}

        it_behaves_like('do nothing', 400)
      end

      context 'with incorrect ID' do
        subject { put "/web/1.0/goals/#{goal.id + 1}", params: params }

        it_behaves_like('do nothing', 404)
      end

      context 'with error' do
        let(:params) do
          { goal: { name: 'Name', aim: 'equal', limit: 3, period: :once, size: 'm', auto_reactivate_every_n_days: -1 } }
        end

        it 'does not update Goal' do
          expect { subject }.not_to(change { goal.reload })
        end
        it 'does not call GenerateDaily' do
          expect(GenerateDaily).not_to receive(:call)
          subject
        end
      end

      context 'with success' do
        it 'updates Goal correctly' do
          subject
          expect(goal.reload).to have_attributes(
            user_id: user.id,
            name: 'Name',
            limit: 3,
            aim: 'equal',
            period: 'per_day',
            size: 'm',
            incentive_id: incentive.id,
            is_completed: false
          )
        end
        it 'calls GenerateDaily' do
          expect(GenerateDaily).to receive(:call).with(goal)
          subject
        end
      end

      context 'with once' do
        let(:params) do
          {
            goal: {
              name: 'Name',
              aim: 'equal',
              limit: 1,
              period: :once,
              size: 'm',
              incentive: incentive.id,
              auto_reactivate_every_n_days: 3,
              auto_reactivate_start_from: Date.current.strftime('%d.%m.%Y')
            }
          }
        end

        it 'creates Goal' do
          expect { subject }.to change { Goal.count }.by(1)
        end
        it 'creates correct Goal' do
          subject
          expect(Goal.last).to have_attributes(
            user_id: user.id,
            name: 'Name',
            limit: 1,
            aim: 'equal',
            period: 'once',
            size: 'm',
            incentive_id: incentive.id,
            is_completed: false,
            auto_reactivate_every_n_days: 3,
            auto_reactivate_start_from: Date.current
          )
        end
        it 'calls GenerateDaily' do
          expect(GenerateDaily).to receive(:call)
          subject
        end
      end
    end
  end

  describe '#reactualize' do
    subject { patch "/web/1.0/goals/#{goal.id}/reactualize" }

    let(:goal) { create(:goal, user: user, aim: 'equal', limit: 1, period: :once, is_completed: true) }

    shared_examples 'do nothing' do |code|
      it "returns #{code}" do
        subject
        expect(response).to have_http_status(code)
      end
      it 'does not update Goal is completed' do
        expect { subject }.not_to(change { goal.reload.is_completed })
      end
      it 'does not call GenerateDaily' do
        expect(GenerateDaily).not_to receive(:call)
        subject
      end
    end

    context 'without current user' do
      it_behaves_like('do nothing', 401)
    end

    context 'with current user' do
      before { sign_in(user) }

      context 'with incorrect ID' do
        subject { patch "/web/1.0/goals/#{goal.id + 1}/reactualize" }

        it_behaves_like('do nothing', 404)
      end

      context 'with non completed' do
        let(:goal) { create(:goal, user: user, aim: 'equal', limit: 1, period: :once, is_completed: false) }

        it 'does not update Goal is completed' do
          expect { subject }.not_to(change { goal.reload.is_completed })
        end
      end

      context 'with completed' do
        it 'updates Goal is completed' do
          expect { subject }.to change { goal.reload.is_completed }.to(false)
        end
        it 'calls GenerateDaily' do
          expect(GenerateDaily).to receive(:call).with(goal)
          subject
        end
      end
    end
  end

  describe '#destroy' do
    subject { delete "/web/1.0/goals/#{goal.id}" }

    let!(:goal) { create(:goal, user: user) }

    shared_examples 'do nothing' do |code|
      it "returns #{code}" do
        subject
        expect(response).to have_http_status(code)
      end
      it 'does not delete Goal' do
        expect { subject }.not_to(change { Goal.count })
      end
    end

    context 'without current user' do
      it_behaves_like('do nothing', 401)
    end

    context 'with current user' do
      before { sign_in(user) }

      context 'with incorrect ID' do
        subject { delete "/web/1.0/goals/#{goal.id + 1}" }

        it_behaves_like('do nothing', 404)
      end

      context 'with success' do
        it 'deletes Goal' do
          expect { subject }.to change { Goal.count }.by(-1)
        end
      end
    end
  end
end
