class User < ApplicationRecord
  has_many :community_hosts,
           foreign_key: 'host_id',
           dependent: :destroy
  has_many :hosting_communities,
            class_name: 'Community',
            through: :community_hosts

  has_many :community_participants,
           foreign_key: 'participant_id',
           dependent: :destroy
  has_many :participating_communities,
            class_name: 'Community',
            through: :community_participants

  has_many :community_followers,
           foreign_key: 'follower_id',
           dependent: :destroy
  has_many :following_communities,
            class_name: 'Community',
            through: :community_followers

  has_many :hosting_cyphers,
           class_name: 'Cypher',
           foreign_key: 'host_id',
           dependent: :destroy

  has_many :cypher_participants,
           foreign_key: 'participant_id',
           dependent: :destroy
  has_many :participating_cyphers,
           class_name: 'Cypher',
           through: :cypher_participants

  has_many :posts

  has_many :api_keys,
           dependent: :destroy

  validates :name, presence: true
  validates :home, presence: true
  validates :bio, presence: true
  validates :type_flag, presence: true

  include FlagShihTzu

  has_flags 1 => :mc,
            2 => :dj,
            3 => :trackmaker,
            :column => 'type_flag'

  mount_uploader :thumbnail, UserThumbnailUploader
  serialize :thumbnail, JSON


  def hosting_community?(community_id)
    community = Community.find(community_id)
    if community.hosts.ids.include?(self.id)
      return true
    else
      return false
    end
  end

  def hosting_cypher?(cypher_id)
    cypher = Cypher.find(cypher_id)
    if cypher.host_id == self.id
      return true
    else
      return false
    end
  end
end
