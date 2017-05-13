require 'rails_helper'

describe Community do
  describe 'with DB constraint' do
    before do
      @community = create(:community)
    end

    it {have_not_null_constraint_on(:name)}

    it {have_not_null_constraint_on(:home)}

    it {have_not_null_constraint_on(:bio)}
  end

  describe 'with validation' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validates_uniqueness_of(:name)}

    it { is_expected.to validate_presence_of(:home) }

    it { is_expected.to validate_presence_of(:bio) }
  end
end