FactoryGirl.define do
  factory :community_follower do
    follower
    following_community
  end
end