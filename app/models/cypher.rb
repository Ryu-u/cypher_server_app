class Cypher < ApplicationRecord
  belongs_to :community
  belongs_to :host, class_name: 'User', foreign_key: 'host_id'
end
