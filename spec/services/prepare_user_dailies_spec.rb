require 'rails_helper'

describe PrepareUserDailies do
  subject { described_class.call(user) }

  shared_examples 'do nothing' do
    it 'does not call DropOldDailies' do
      expect(DropOldDailies).not_to receive(:call)
      subject
    end
    it 'does not call GenerateDailies' do
      expect(GenerateDailies).not_to receive(:call)
      subject
    end
    it 'does not call AutoReactivateGoals' do
      expect(AutoReactivateGoals).not_to receive(:call)
      subject
    end
    it 'does not call FreezeDailies' do
      expect(FreezeDailies).not_to receive(:call)
      subject
    end
  end

  context 'without user' do
    let(:user) {}

    it_behaves_like 'do nothing'
  end

  context 'with freshly updated user' do
    let(:user) { create(:user, last_visited_at: (Time.current.beginning_of_day + 1.minute)) }

    it_behaves_like 'do nothing'
  end

  context 'with not updated user' do
    let(:user) { create(:user, last_visited_at: (Time.current.beginning_of_day - 1.minute)) }

    it 'calls DropOldDailies' do
      expect(DropOldDailies).to receive(:call)
      subject
    end
    it 'calls GenerateDailies' do
      expect(GenerateDailies).to receive(:call)
      subject
    end
    it 'calls AutoReactivateGoals' do
      expect(AutoReactivateGoals).to receive(:call)
      subject
    end
    it 'calls FreezeDailies' do
      expect(FreezeDailies).to receive(:call)
      subject
    end
  end
end
