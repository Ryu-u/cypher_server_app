class Community < ApplicationRecord
  has_many :community_hosts
  has_many :hosts, class_name: 'User', through: :community_hosts
end
