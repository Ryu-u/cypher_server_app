class Cypher < ApplicationRecord
  belongs_to :community
  belongs_to :host, class_name: 'User',
             foreign_key: 'host_id'

  has_many :cypher_participants,
           dependent: :destroy
  has_many :participants,
           class_name: 'User',
           through: :cypher_participants

  has_many :posts

  has_many :cypher_tags
  has_many :tags,
           through: :cypher_tags,
           dependent: :destroy

  validates :name, presence: true
  validates :serial_num, presence: true
  validates :community_id, presence: true
  validates :info, presence: true
  validates :cypher_from, presence: true
  validates :cypher_to, presence: true
  validates :place, presence: true
  validates :host_id, presence: true
end
