require 'rails_helper'

describe Post do
  context 'add not null constraint' do
    it {have_not_null_constraint_on(:user_id)}
    it {have_not_null_constraint_on(:cypher_id)}
  end

  context 'association' do
    it "belongs to cypher and user" do
      community = create(:community)
      user = create(:user)

      cypher = build(:cypher)

      cypher.community = community
      cypher.host = user

      cypher.save

      post = build(:post)

      post.cypher = cypher
      post.user = user

      post.save

      expect(post.cypher_id).to eq cypher.id
      expect(post.user_id).to eq user.id
    end
  end
end
