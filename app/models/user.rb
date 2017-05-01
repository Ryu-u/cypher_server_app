class User < ApplicationRecord
  has_many :community_hosts, foreign_key: 'host_id'
  has_many :communities, through: :community_hosts
end
