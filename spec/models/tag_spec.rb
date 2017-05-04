require 'rails_helper'

describe Tag do
  before do
    let(:community){create(:community)}
    let(:user){create(:user)}
    let(cypher){build(:cypher)}
    cypher.host = user
    cypher.community = community
    cypher.save

    let(:tag){build(:tag)}
    community.tags << tag
    tag.save
  end
  
  context 'relation to community' do
    it 'belongs to community' do
      expect(community.tags).to eq tag.all
    end
  end

end