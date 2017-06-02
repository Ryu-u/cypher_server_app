class CypherParticipant < ApplicationRecord
  belongs_to :participating_cypher, class_name: 'Cypher', foreign_key: 'cypher_id'
  belongs_to :participant, class_name: 'User', foreign_key: 'participant_id'

  validates :cypher_id, presence: true, uniqueness:{scope: :participant_id}
  validates :participant_id, presence: true
end
