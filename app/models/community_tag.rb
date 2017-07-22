class CommunityTag < ApplicationRecord
  belongs_to :community
  belongs_to :tag

  validates :community_id,
            presence: true,
            uniqueness: {scope: :tag_id}
  validates :tag_id,
            presence: true
end
