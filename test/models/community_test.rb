require 'test_helper'

class CommunityTest < ActiveSupport::TestCase
  test 'relation between community and host' do
    hosted_community = Community.new(name:'aaaa',
                           home:'豊中',
                           bio:'頑張ります')
    hosted_community.save
    hosting_user = User.new(name:'name:aaaa_host')
    hosting_user.save

    hosted_community.hosts << hosting_user
    assert_not hosted_community.hosts.empty?, 'failure of relation between community and host'
  end

  test 'relation between community and participant' do
    joined_community = Community.new(name:'aaaa',
                                     home:'豊中',
                                     bio:'頑張ります')
    joined_community.save
    joining_user = User.new(name:'name:aaaa_participant')
    joining_user.save

    joined_community.participants << joining_user
    assert_not joined_community.participants.empty?, 'failure of relation between community and participant'
  end

  test 'relation between community and follower' do
    followed_community = Community.new(name:'aaaa',
                                     home:'豊中',
                                     bio:'頑張ります')
    followed_community.save
    following_user = User.new(name:'name:aaaa_follower')
    following_user.save

    followed_community.followers << following_user
    assert_not followed_community.followers.empty?, 'failure of relation between community and follower'
  end
  
end
