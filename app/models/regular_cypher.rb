class RegularCypher < ApplicationRecord
  belongs_to :community

  validates :community_id, presence: true, uniqueness: true
  validates :info, presence: true
  validates :cypher_day, presence: true
  validates :cypher_from, presence: true
  validates :cypher_to, presence: true
  validates :place, presence: true

  def print_day
    day = nil
    case self.cypher_day
      when 0 then
        day = '日'
      when 1
        day = '月'
      when 2
        day = '火'
      when 3
        day = '水'
      when 4
        day = '木'
      when 5
        day = '金'
      when 6
        day = '土'
    end
    return day
  end

end
