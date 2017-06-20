class User < ApplicationRecord
  has_many :community_hosts, foreign_key: 'host_id'
  has_many :hosting_communities,
            class_name: 'Community',
            through: :community_hosts

  has_many :community_participants, foreign_key: 'participant_id'
  has_many :participating_communities,
            class_name: 'Community',
            through: :community_participants

  has_many :community_followers, foreign_key: 'follower_id'
  has_many :following_communities,
            class_name: 'Community',
            through: :community_followers

  has_many :hosting_cyphers, class_name: 'Cypher', foreign_key: 'host_id'

  has_many :cypher_participants, foreign_key: 'participant_id'
  has_many :participating_cyphers, class_name: 'Cypher', through: :cypher_participants

  has_many :posts

  has_one :api_key

  validates :name, presence: true
  validates :home, presence: true
  validates :bio, presence: true
  validates :type_flag, presence: true
end
