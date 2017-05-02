class CommunityParticipant < ApplicationRecord
  belongs_to :community
  belongs_to :participant, foreign_key: 'participant_id', class_name: 'User'
end
