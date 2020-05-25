require 'rails_helper'

describe UpdateDaily do
  subject { described_class.call(daily, action) }

  let(:daily) { create(:daily, value: 3) }

  context 'with action == increment' do
    let(:action) { :increment }

    it 'increments value' do
      expect { subject }.to change { daily.reload.value }.to(4)
    end
    it 'calls RecalcDailyStatus' do
      expect(RecalcDailyStatus).to receive(:call).with(daily, current_daily: true)
      subject
    end
  end

  context 'with action == decrement' do
    let(:action) { :decrement }

    it 'decrements value' do
      expect { subject }.to change { daily.reload.value }.to(2)
    end
    it 'calls RecalcDailyStatus' do
      expect(RecalcDailyStatus).to receive(:call).with(daily, current_daily: true)
      subject
    end
  end

  context 'with unknown action' do
    let(:action) { :unknown }

    it 'does not change value' do
      expect { subject }.not_to(change { daily.reload.value })
    end
    it 'calls RecalcDailyStatus' do
      expect(RecalcDailyStatus).to receive(:call).with(daily, current_daily: true)
      subject
    end
  end

  context 'with yesterday daily' do
    let(:daily) { create(:daily, value: 3, date: Date.yesterday) }
    let(:action) { :decrement }

    it 'decrements value' do
      expect { subject }.to change { daily.reload.value }.to(2)
    end
    it 'calls RecalcDailyStatus' do
      expect(RecalcDailyStatus).to receive(:call).with(daily, current_daily: false)
      subject
    end
  end
end
