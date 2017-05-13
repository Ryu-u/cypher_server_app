require 'rails_helper'

describe Community do
  describe 'with DB constraint' do
    it {have_not_null_constraint_on(:name)}
    it {have_not_null_constraint_on(:home)}
    it {have_not_null_constraint_on(:bio)}

    describe 'of uniqueness' do
      it 'should not have the same value in different records of name column ' do
        expect do
          existing_community = Community.create(name:"AAAA", home:"AAAA", bio:"AAAA")
          new_community = build(:community)
          new_community.name = existing_community.name
          new_community.save!(validate: false)
        end.to raise_error( ActiveRecord::RecordNotUnique )
      end
    end
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