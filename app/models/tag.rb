class Tag < ApplicationRecord
  has_many :community_tags
  has_many :communities, through: :community_tags
end
