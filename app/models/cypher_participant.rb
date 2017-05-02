class CypherParticipant < ApplicationRecord
  belongs_to :cypher
  belongs_to :participant, class_name: 'User', foreign_key: 'participant_id'
end
