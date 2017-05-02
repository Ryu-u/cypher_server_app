class User < ApplicationRecord
  has_many :community_hosts, foreign_key: 'host_id'
  has_many :communities, through: :community_hosts

  has_many :community_participants, foreign_key: 'participant_id'
  has_many :communities, through: :community_participants

  has_many :community_followers, foreign_key: 'follower_id'
  has_many :communities, through: :community_followers

  has_many :cyphers, class_name: 'Cypher', foreign_key: 'host_id'

  has_many :cypher_participants, foreign_key: 'participant_id'
  has_many :cyphers, through: :cypher_participants
end
