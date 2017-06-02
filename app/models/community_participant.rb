class CommunityParticipant < ApplicationRecord
  belongs_to :participating_community, foreign_key: 'community_id', class_name: 'Community'
  belongs_to :participant, foreign_key: 'participant_id', class_name: 'User'

  validates :community_id, presence: true, uniqueness: { scope: :participant_id }
  validates :participant_id, presence: true
end
