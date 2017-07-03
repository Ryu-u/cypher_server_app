class Community < ApplicationRecord
  has_many :community_hosts
  has_many :hosts, class_name: 'User', through: :community_hosts

  has_many :community_participants
  has_many :participants, class_name: 'User', through: :community_participants

  has_many :community_followers
  has_many :followers, class_name: 'User', through: :community_followers

  has_many :cyphers

  has_one :regular_cypher

  has_many :community_tags
  has_many :tags, through: :community_tags

  validates :name, presence: true, uniqueness: true
  validates :home, presence: true
  validates :bio, presence: true

  mount_uploader :thumbnail, CommunityThumbnailUploader
  serialize :thumbnail, JSON
end
