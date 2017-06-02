class CommunityFollower < ApplicationRecord
  belongs_to :following_community, foreign_key: 'community_id', class_name: 'Community'
  belongs_to :follower, foreign_key: 'follower_id', class_name: 'User'

  validates :community_id, presence: true, uniqueness: { scope: :follower_id }
  validates :follower_id, presence: true
end
