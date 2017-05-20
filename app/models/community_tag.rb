class CommunityTag < ApplicationRecord
  belongs_to :community
  belongs_to :tag

  validates presence: true, uniqueness: {scope: :tag_id}
  validates presence: true
end
