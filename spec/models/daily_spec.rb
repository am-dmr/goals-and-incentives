require 'rails_helper'

describe Daily do
  subject { create(:daily) }

  describe 'associations' do
    it { is_expected.to belong_to(:goal) }
    it { is_expected.to belong_to(:incentive).optional }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:goal) }
    it { is_expected.to validate_presence_of(:value) }
    it { is_expected.to validate_presence_of(:date) }
    it { is_expected.to validate_presence_of(:status) }
    it { is_expected.to validate_presence_of(:incentive_status) }
  end
end
