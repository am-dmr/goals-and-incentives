require 'rails_helper'

describe Goal do
  subject { create(:goal) }

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:user) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:limit) }
    it { is_expected.to validate_presence_of(:aim) }
    it { is_expected.to validate_presence_of(:period) }
    it { is_expected.to validate_presence_of(:size) }
  end
end
