class CommunityHost < ApplicationRecord
  belongs_to :hosting_community, foreign_key: 'community_id', class_name: 'Community'
  belongs_to :host, foreign_key: 'host_id', class_name: 'User'

  validates :community_id, presence: true, uniqueness: { scope: :host_id }
  validates :host_id, presence: true
end
