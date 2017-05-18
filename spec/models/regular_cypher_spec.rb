require 'rails_helper'

describe RegularCypher do
  describe 'with DB' do
    it {have_not_null_constraint_on(:community_id)}
    it {have_not_null_constraint_on(:info)}
    it {have_not_null_constraint_on(:cypher_day)}
    it {have_not_null_constraint_on(:cypher_from)}
    it {have_not_null_constraint_on(:cypher_to)}
    it {have_not_null_constraint_on(:place)}

    context 'of index' do
      it 'should not have the same community_id in different records' do
        regular_cypher = build(:regular_cypher)
        community = create(:community)
        community.regular_cypher = regular_cypher
        regular_cypher.save
        another_regular_cypher = build(:regular_cypher)
        expect do
          another_regular_cypher.community_id = regular_cypher.community_id
          another_regular_cypher.save!(validate: false)
        end.to raise_error(ActiveRecord::RecordNotUnique)
      end
    end
  end

  describe 'with model' do
    context 'association' do
      it {is_expected.to belong_to(:community)}
    end

    context 'validation' do
      it { is_expected.to validate_presence_of(:community_id) }
      it { is_expected.to validate_presence_of(:info) }
      it { is_expected.to validate_presence_of(:cypher_day) }
      it { is_expected.to validate_presence_of(:cypher_from) }
      it { is_expected.to validate_presence_of(:cypher_to) }
      it { is_expected.to validate_presence_of(:place) }

      describe 'of uniqueness' do
        subject{build(:regular_cypher)}
        it { is_expected.to validate_uniqueness_of(:community_id) }
      end
    end
  end

end