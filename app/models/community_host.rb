class CommunityHost < ApplicationRecord
  belongs_to :community
  belongs_to :host, foreign_key: 'host_id', class_name: 'User'
end
