require 'rails_helper'

describe Incentive do
  subject { create(:incentive) }

  describe 'associations' do
    it { is_expected.to belong_to(:user) }

    it { is_expected.to have_many(:dailies) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:user) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:size) }
  end
end
