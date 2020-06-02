require 'rails_helper'

describe Goal do
  subject { create(:goal) }

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:incentive).optional }

    it { is_expected.to have_many(:dailies) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:user) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:limit) }
    it { is_expected.to validate_presence_of(:aim) }
    it { is_expected.to validate_presence_of(:period) }
    it { is_expected.to validate_presence_of(:size) }

    describe '#once_aim_and_limit' do
      shared_examples 'has no error' do |attr, val|
        before { subject.public_send("#{attr}=", val) }

        it 'is valid' do
          expect(subject).to be_valid
        end
      end

      shared_examples 'has error' do |attr, val|
        before { subject.public_send("#{attr}=", val) }

        it "has error on #{attr}" do
          subject.valid?
          expect(subject.errors[attr]).to be_present
        end
      end

      context 'with period == per day' do
        subject { create(:goal, period: :per_day) }

        described_class.aims.each_key { |aim| it_behaves_like('has no error', :aim, aim) }
        [1, 2, 3].each { |limit| it_behaves_like('has no error', :limit, limit) }
      end

      context 'with period == per week' do
        subject { create(:goal, period: :per_week) }

        described_class.aims.each_key { |aim| it_behaves_like('has no error', :aim, aim) }
        [1, 2].each { |limit| it_behaves_like('has no error', :limit, limit) }
      end

      context 'with period == once' do
        subject { create(:goal, period: :once) }

        it_behaves_like('has error', :aim, :less_than)
        it_behaves_like('has error', :aim, :greater_than)
        it_behaves_like('has no error', :aim, :equal)

        it_behaves_like('has no error', :limit, 1)
        it_behaves_like('has error', :limit, 2)
      end
    end

    describe '#auto_reactivation' do
      shared_examples 'not once' do
        context 'with both' do
          it 'is invalid' do
            subject.auto_reactivate_every_n_days = 2
            subject.auto_reactivate_start_from = Date.current
            subject.valid?
            expect(subject.errors[:auto_reactivate_every_n_days]).to be_present
          end
        end

        context 'without start from' do
          it 'is invalid' do
            subject.auto_reactivate_every_n_days = 2
            subject.valid?
            expect(subject.errors[:auto_reactivate_start_from]).to be_present
          end
        end
      end

      context 'with per day' do
        subject { create(:goal, period: :per_day) }

        it_behaves_like('not once')
      end

      context 'with per week' do
        subject { create(:goal, period: :per_week) }

        it_behaves_like('not once')
      end

      context 'with once' do
        subject { create(:goal, period: :once) }

        context 'with both' do
          it 'is valid' do
            subject.auto_reactivate_every_n_days = 2
            subject.auto_reactivate_start_from = Date.current
            expect(subject).to be_valid
          end
        end

        context 'without start from' do
          it 'is invalid' do
            subject.auto_reactivate_every_n_days = 2
            subject.valid?
            expect(subject.errors[:auto_reactivate_start_from]).to be_present
          end
        end
      end
    end
  end
end
