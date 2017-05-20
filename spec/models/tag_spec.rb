require 'rails_helper'

describe Tag do
  describe 'with DB' do
    describe 'not null constraint' do
      it {have_not_null_constraint_on(:content)}
    end
  end

  describe 'with model' do
    describe 'validation' do
      context 'of presence' do
      it {is_expected.to validate_presence_of(:content)}
      end

      context 'of uniqueness' do
        subject{build(:tag)}
        it {is_expected.to validate_uniqueness_of(:content)}
      end

      context 'association' do
        it {is_expected.to have_many(:community_tags)}
        it {is_expected.to have_many(:communities).through(:community_tags)}
      end
    end
  end
end