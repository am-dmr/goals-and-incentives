require 'rails_helper'

describe Web::V1::IncentivesController do
  let(:user) { create(:user) }

  describe '#create' do
    subject { post '/web/1.0/incentives', params: params }

    let(:params) { { incentive: { name: 'Name', size: 'm' } } }

    shared_examples 'do nothing' do |code|
      it "returns #{code}" do
        subject
        expect(response).to have_http_status(code)
      end
      it 'does not create Incentive' do
        expect { subject }.not_to(change { Incentive.count })
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
        let(:params) { { incentive: {} } }

        it 'does not create Incentive' do
          expect { subject }.not_to(change { Incentive.count })
        end
      end

      context 'with success' do
        it 'creates Incentive' do
          expect { subject }.to change { Incentive.count }.by(1)
        end
        it 'creates correct Incentive' do
          subject
          expect(Incentive.last).to have_attributes(
            user_id: user.id,
            name: 'Name',
            size: 'm'
          )
        end
      end
    end
  end

  describe '#update' do
    subject { put "/web/1.0/incentives/#{incentive.id}", params: params }

    let(:incentive) { create(:incentive, user: user, name: 'ameN', size: 'l') }

    let(:params) { { incentive: { name: 'Name', size: 'm' } } }

    shared_examples 'do nothing' do |code|
      it "returns #{code}" do
        subject
        expect(response).to have_http_status(code)
      end
      it 'does not update Incentive' do
        expect { subject }.not_to(change { incentive.reload })
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
        subject { put "/web/1.0/incentives/#{incentive.id + 1}", params: params }

        it_behaves_like('do nothing', 404)
      end

      context 'with error' do
        let(:params) { { incentive: { name: 'Name' } } }

        it 'does not update Incentive' do
          expect { subject }.not_to(change { incentive.reload })
        end
      end

      context 'with success' do
        it 'updates Incentive correctly' do
          subject
          expect(incentive.reload).to have_attributes(
            user_id: user.id,
            name: 'Name',
            size: 'm'
          )
        end
      end
    end
  end

  describe '#destroy' do
    subject { delete "/web/1.0/incentives/#{incentive.id}" }

    let!(:incentive) { create(:incentive, user: user) }

    shared_examples 'do nothing' do |code|
      it "returns #{code}" do
        subject
        expect(response).to have_http_status(code)
      end
      it 'does not delete Incentive' do
        expect { subject }.not_to(change { Incentive.count })
      end
    end

    context 'without current user' do
      it_behaves_like('do nothing', 401)
    end

    context 'with current user' do
      before { sign_in(user) }

      context 'with incorrect ID' do
        subject { delete "/web/1.0/incentives/#{incentive.id + 1}" }

        it_behaves_like('do nothing', 404)
      end

      context 'with success' do
        it 'deletes Incentive' do
          expect { subject }.to change { Incentive.count }.by(-1)
        end
      end
    end
  end
end
