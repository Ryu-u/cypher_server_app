class Post < ApplicationRecord
  belongs_to :user
  belongs_to :cypher

  validates :cypher_id, presence: true
  validates :user_id, presence: true

end
