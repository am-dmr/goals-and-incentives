require 'rails_helper'

describe Web::V1::DashboardController do
  let(:user) { create(:user) }

  describe '#index' do
    subject { get '/web/1.0/dashboard' }

    before { sign_in(user) }

    it 'updates user last_visited_at' do
      Timecop.freeze do
        expect { subject }.to change { user.reload.last_visited_at.to_i }.to(Time.current.to_i)
      end
    end
    it 'calls PrepareUserDailies' do
      expect(PrepareUserDailies).to receive(:call).with(user)
      subject
    end
  end
end
