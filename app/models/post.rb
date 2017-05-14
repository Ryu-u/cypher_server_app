class Post < ApplicationRecord
  belongs_to :user
  belongs_to :cypher

  validates :cypher_id, presence: true, uniqueness: { scope: :user_id }
  validates :user_id, presence: true

end
