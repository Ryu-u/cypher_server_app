class Tag < ApplicationRecord
  has_many :community_tags
  has_many :communities,
           through: :community_tags

  has_many :cypher_tags
  has_many :cyphers,
           through: :cypher_tags

  validates :content, presence: true, uniqueness: true
end
