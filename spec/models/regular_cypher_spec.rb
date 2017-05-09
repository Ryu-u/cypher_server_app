require 'rails_helper'

describe RegularCypher do
  context 'add not null constraint' do
    it {have_not_null_constraint_on(:community_id)}
    it {have_not_null_constraint_on(:info)}
    it {have_not_null_constraint_on(:cypher_day)}
    it {have_not_null_constraint_on(:cypher_from)}
    it {have_not_null_constraint_on(:cypher_to)}
    it {have_not_null_constraint_on(:place)}
  end

  context 'association' do
    it 'belongs to community' do
      community = create(:community)
      regular_cypher = build(:regular_cypher)
      community.regular_cypher = regular_cypher

      regular_cypher.save
      expect(regular_cypher.community_id).to eq community.id
    end
  end
end