require 'rails_helper'

describe Community do
  describe 'with DB constraint' do
    it {have_not_null_constraint_on(:name)}
    it {have_not_null_constraint_on(:home)}
    it {have_not_null_constraint_on(:bio)}
  end

  describe 'with validation' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:home) }
    it { is_expected.to validate_presence_of(:bio) }

    describe 'of uniqueness' do
      subject{build(:community)}
      it { is_expected.to validate_uniqueness_of(:name) }
    end
  end
end