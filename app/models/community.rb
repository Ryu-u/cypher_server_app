class Community < ApplicationRecord
  has_many :community_hosts,
           dependent: :destroy
  has_many :hosts,
           class_name: 'User',
           through: :community_hosts

  has_many :community_participants,
           dependent: :destroy
  has_many :participants,
           class_name: 'User',
           through: :community_participants

  has_many :community_followers,
           dependent: :destroy
  has_many :followers,
           class_name: 'User',
           through: :community_followers

  has_many :cyphers,
           dependent: :destroy

  has_one :regular_cypher,
          dependent: :destroy

  has_many :community_tags,
           dependent: :destroy
  has_many :tags,
           through: :community_tags

  validates :name, presence: true, uniqueness: true
  validates :home, presence: true
  validates :bio, presence: true

  mount_uploader :thumbnail, CommunityThumbnailUploader
  serialize :thumbnail, JSON
end
