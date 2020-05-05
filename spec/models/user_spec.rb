require 'rails_helper'

describe User do
  subject { create(:user) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:username) }
  
    it { is_expected.to validate_uniqueness_of(:username) }
  end
end
