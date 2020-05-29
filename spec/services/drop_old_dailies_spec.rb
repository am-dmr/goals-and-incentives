require 'rails_helper'

describe DropOldDailies do
  subject { described_class.call(user) }

  let(:user) { create(:user) }
  let(:goal) { create(:goal, user: user) }
  let!(:anothers_daily) { create(:daily, date: 30.days.ago.to_date) }
  let!(:new_daily) { create(:daily, goal: goal, date: 10.days.ago.to_date) }

  before { create(:daily, goal: goal, date: 30.days.ago.to_date) }

  it "does not drop another's daily" do
    expect { subject }.not_to(change { anothers_daily.reload })
  end
  it 'does not drop new daily' do
    expect { subject }.not_to(change { new_daily.reload })
  end
  it 'drops old daily' do
    expect { subject }.to change { Daily.count }.by(-1)
  end
end
