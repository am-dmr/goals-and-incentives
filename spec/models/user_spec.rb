require 'rails_helper'

describe User do
  subject { create(:user) }

  describe 'associations' do
    it { is_expected.to have_many(:goals) }
    it { is_expected.to have_many(:incentives) }
    it { is_expected.to have_many(:dailies) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:username) }

    it { is_expected.to validate_uniqueness_of(:username) }
  end
end
