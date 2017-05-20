class CypherTag < ApplicationRecord
  belongs_to :cypher
  belongs_to :tag

  validates :cypher_id, presence: true, uniqueness: {scope: :tag_id}
  validates :tag_id, presence: true
end
