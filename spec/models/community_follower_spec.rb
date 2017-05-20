require 'rails_helper'

describe CommunityFollower do
  describe 'with DB' do
    context 'not null constraint' do
      it {have_not_null_constraint_on(:community_id)}
      it {have_not_null_constraint_on(:follower_id)}
    end

    context 'of index' do
      it 'should not have two records whith have the same combination of community_id and follower id' do
        expect do
          community = Community.create(name: "aaaa", home: "aaaa", bio: "aaaa")
          follower = User.create(name: "aaaa", home: "aaaa", bio: "aaaa", type_flag:1)
          community.followers << follower
          community.save
          community_follower = CommunityFollower.new(community_id: community.id, follower_id: follower.id)
          community_follower.save!(validate: false)
        end.to raise_error(ActiveRecord::RecordNotUnique)
      end
    end
  end

  describe 'with model' do
    context 'of presence' do
      it { is_expected.to validate_presence_of(:community_id) }
      it { is_expected.to validate_presence_of(:follower_id) }
    end

    context 'of uniqueness' do
      subject{CommunityFollower.new(community_id:1, follower_id:1)}
      it { is_expected.to validate_uniqueness_of(:community_id).scoped_to(:follower_id) }
    end

    context 'association' do
      it {is_expected.to belong_to(:community)}
      it {is_expected.to belong_to(:follower)}
    end
  end
end