require 'rails_helper'

describe Community do
  describe 'with DB' do
    context 'not null constraint' do
      it {have_not_null_constraint_on(:name)}
      it {have_not_null_constraint_on(:home)}
      it {have_not_null_constraint_on(:bio)}
    end

    context 'of uniqueness' do
      it 'should not have the same value of name column in different records' do
        expect do
          existing_community = create(:community)
          new_community = build(:community)
          new_community.name = existing_community.name
          new_community.save!(validate: false)
        end.to raise_error( ActiveRecord::RecordNotUnique )
      end
    end
  end

  describe 'with model' do
    context 'validation' do
      describe 'of presence' do
        it { is_expected.to validate_presence_of(:name) }
        it { is_expected.to validate_presence_of(:home) }
        it { is_expected.to validate_presence_of(:bio) }
      end

      describe 'of uniqueness' do
        subject{build(:community)}
        it { is_expected.to validate_uniqueness_of(:name) }
      end
    end

    context 'association' do
      it {is_expected.to have_many(:community_hosts)}
      it {is_expected.to have_many(:hosts).through(:community_hosts)}
      it {is_expected.to have_many(:community_participants)}
      it {is_expected.to have_many(:participants).through(:community_participants)}
      it {is_expected.to have_many(:community_followers)}
      it {is_expected.to have_many(:followers).through(:community_followers)}
      it {is_expected.to have_many(:cyphers)}
      it {is_expected.to have_one(:regular_cypher)}
      it {is_expected.to have_many(:community_tags)}
      it {is_expected.to have_many(:tags).through(:community_tags)}
    end
  end
end