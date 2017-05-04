class Cypher < ApplicationRecord
  belongs_to :community
  belongs_to :host, class_name: 'User', foreign_key: 'host_id'

  has_many :cypher_participants
  has_many :participants, class_name: 'User', through: :cypher_participants

  has_many :posts

  has_many :cypher_tags
  has_many :tags, through: :cypher_tags
end
