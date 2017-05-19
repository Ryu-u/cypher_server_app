class RegularCypher < ApplicationRecord
  belongs_to :community

  validates :community_id, presence: true, uniqueness: true
  validates :info, presence: true
  validates :cypher_day, presence: true
  validates :cypher_from, presence: true
  validates :cypher_to, presence: true
  validates :place, presence: true
end
