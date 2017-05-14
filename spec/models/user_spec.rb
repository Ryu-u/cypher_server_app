require 'rails_helper'

describe User do
  describe 'with DB' do
    it { have_not_null_constraint_on(:name) }
    it { have_not_null_constraint_on(:home) }
    it { have_not_null_constraint_on(:bio) }
    it { have_not_null_constraint_on(:type_flag) }
  end

  describe 'with validation' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:home) }
    it { is_expected.to validate_presence_of(:bio) }
    it { is_expected.to validate_presence_of(:type_flag) }
  end
end