require 'rails_helper'

describe RegularCypher do
  it 'belongs to community' do
    community = create(:community)
    regular_cypher = build(:regular_cypher)
    community.regular_cypher = regular_cypher

    regular_cypher.save
    expect(regular_cypher.community_id).to eq community.id
  end
end