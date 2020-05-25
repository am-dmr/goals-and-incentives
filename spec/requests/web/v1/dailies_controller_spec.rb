require 'rails_helper'

describe Web::V1::DailiesController do
  let(:user) { create(:user) }
  let(:goal) { create(:goal, user: user) }
  let(:daily) { create(:daily, goal: goal) }

  shared_examples 'do nothing' do |code|
    it "returns #{code}" do
      subject
      expect(response).to have_http_status(code)
    end
    it 'does not call UpdateDaily' do
      expect(UpdateDaily).not_to receive(:call)
      subject
    end
  end

  describe '#increment' do
    subject { patch "/web/1.0/dailies/#{daily.id}/increment", xhr: true }

    context 'without current user' do
      it_behaves_like('do nothing', 401)
    end

    context 'with current user' do
      before { sign_in(user) }

      context "with another's goal" do
        before { goal.update(user: create(:user)) }

        it_behaves_like('do nothing', 404)
      end

      context 'with incorrect ID' do
        subject { patch "/web/1.0/dailies/#{daily.id + 1}/increment", xhr: true }

        it_behaves_like('do nothing', 404)
      end

      context 'with correct params' do
        it 'returns 200' do
          subject
          expect(response).to have_http_status(200)
        end
        it 'calls UpdateDaily' do
          expect(UpdateDaily).to receive(:call).with(daily, :increment)
          subject
        end
      end
    end
  end

  describe '#decrement' do
    subject { patch "/web/1.0/dailies/#{daily.id}/decrement", xhr: true }

    context 'without current user' do
      it_behaves_like('do nothing', 401)
    end

    context 'with current user' do
      before { sign_in(user) }

      context "with another's goal" do
        before { goal.update(user: create(:user)) }

        it_behaves_like('do nothing', 404)
      end

      context 'with incorrect ID' do
        subject { patch "/web/1.0/dailies/#{daily.id + 1}/decrement", xhr: true }

        it_behaves_like('do nothing', 404)
      end

      context 'with correct params' do
        it 'returns 200' do
          subject
          expect(response).to have_http_status(200)
        end
        it 'calls UpdateDaily' do
          expect(UpdateDaily).to receive(:call).with(daily, :decrement)
          subject
        end
      end
    end
  end

  describe '#edit_incentive' do
    subject { get "/web/1.0/dailies/#{daily.id}/edit_incentive", xhr: true }

    shared_examples 'do nothing' do |code|
      it "returns #{code}" do
        subject
        expect(response).to have_http_status(code)
      end
    end

    context 'without current user' do
      it_behaves_like('do nothing', 401)
    end

    context 'with current user' do
      before { sign_in(user) }

      context "with another's goal" do
        before { goal.update(user: create(:user)) }

        it_behaves_like('do nothing', 404)
      end

      context 'with incorrect ID' do
        subject { get "/web/1.0/dailies/#{daily.id + 1}/edit_incentive", xhr: true }

        it_behaves_like('do nothing', 404)
      end

      context 'with correct params' do
        it 'returns 200' do
          subject
          expect(response).to have_http_status(200)
        end
      end
    end
  end

  describe '#update_incentive' do
    subject { patch "/web/1.0/dailies/#{daily.id}/update_incentive", params: params, xhr: true }

    let(:incentive) { create(:incentive, user: user) }
    let(:params) { { daily: { incentive: incentive.id } } }

    shared_examples 'do nothing' do |code|
      it "returns #{code}" do
        subject
        expect(response).to have_http_status(code)
      end
      it 'does not update daily.incentive' do
        expect { subject }.not_to(change { daily.reload.incentive })
      end
    end

    context 'without current user' do
      it_behaves_like('do nothing', 401)
    end

    context 'with current user' do
      before { sign_in(user) }

      context "with another's goal" do
        before { goal.update(user: create(:user)) }

        it_behaves_like('do nothing', 404)
      end

      context "with another's incentive" do
        before { incentive.update(user: create(:user)) }

        it_behaves_like('do nothing', 200)
      end

      context 'with empty params' do
        let(:params) {}

        it_behaves_like('do nothing', 400)
      end

      context 'with incorrect ID' do
        subject { patch "/web/1.0/dailies/#{daily.id + 1}/update_incentive", params: params, xhr: true }

        it_behaves_like('do nothing', 404)
      end

      context 'with correct params & incentive' do
        it 'returns 200' do
          subject
          expect(response).to have_http_status(200)
        end
        it 'updates daily.incentive' do
          expect { subject }.to change { daily.reload.incentive }.to(incentive)
        end
      end

      context 'with correct params & nil' do
        let(:params) { { daily: { incentive: nil } } }

        it_behaves_like('do nothing', 200)
      end
    end
  end

  describe '#toggle_incentive_status' do
    subject { patch "/web/1.0/dailies/#{daily.id}/toggle_incentive_status", xhr: true }

    shared_examples 'do nothing' do |code|
      it "returns #{code}" do
        subject
        expect(response).to have_http_status(code)
      end
      it 'does not update daily.incentive_status' do
        expect { subject }.not_to(change { daily.reload.incentive_status })
      end
    end

    context 'without current user' do
      it_behaves_like('do nothing', 401)
    end

    context 'with current user' do
      before { sign_in(user) }

      context "with another's goal" do
        before { goal.update(user: create(:user)) }

        it_behaves_like('do nothing', 404)
      end

      context 'with incorrect ID' do
        subject { patch "/web/1.0/dailies/#{daily.id + 1}/toggle_incentive_status", xhr: true }

        it_behaves_like('do nothing', 404)
      end

      context 'with incentive_status == none' do
        before { daily.incentive_status_none! }

        it 'returns 200' do
          subject
          expect(response).to have_http_status(200)
        end
        it 'updates daily.incentive_status to success' do
          expect { subject }.to change { daily.reload.incentive_status }.to('success')
        end
      end

      context 'with incentive_status == success' do
        before { daily.incentive_status_success! }

        it 'returns 200' do
          subject
          expect(response).to have_http_status(200)
        end
        it 'updates daily.incentive_status to failed' do
          expect { subject }.to change { daily.reload.incentive_status }.to('failed')
        end
      end

      context 'with incentive_status == failed' do
        before { daily.incentive_status_failed! }

        it 'returns 200' do
          subject
          expect(response).to have_http_status(200)
        end
        it 'updates daily.incentive_status to success' do
          expect { subject }.to change { daily.reload.incentive_status }.to('success')
        end
      end
    end
  end

  describe '#freeze' do
    subject { patch '/web/1.0/dailies/freeze' }

    context 'without current user' do
      it 'returns 401' do
        subject
        expect(response).to have_http_status(401)
      end
      it 'does not call FreezeDailies' do
        expect(FreezeDailies).not_to receive(:call)
        subject
      end
    end

    context 'with current user' do
      before { sign_in(user) }

      it 'redirect to dashboard' do
        expect(subject).to redirect_to(web_v1_dashboard_index_path)
      end
      it 'calls FreezeDailies' do
        expect(FreezeDailies).to receive(:call).with(user, true)
        subject
      end
    end
  end
end
