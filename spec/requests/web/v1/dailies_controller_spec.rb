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
end
