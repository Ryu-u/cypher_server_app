require 'rails_helper'

describe Tag do
  before do
    @community = create(:community)
    @user = create(:user)
    @cypher = build(:cypher)

    @cypher.community = @community
    @cypher.host = @user
    @cypher.save
    @tag = build(:tag)

    @community.tags << @tag
    @cypher.tags << @tag
    @tag.save
  end

  context 'not null constraint' do
    it {have_not_null_constraint_on(:content)}
  end

  context 'association' do
    describe 'on community' do
      it 'has many communities' do
        expect(@tag.communities.first).to eq @community
      end
    end
    describe 'on cypher' do
      it 'has many cyphers' do
        expect(@tag.cyphers.first).to eq @cypher
      end
    end
  end


end