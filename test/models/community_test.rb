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
    refute_nil hosted_community.hosts, 'failure of relation between community and host'
  end

  test 'relation between community and participant' do
    joined_community = Community.new(name:'aaaa',
                                     home:'豊中',
                                     bio:'頑張ります')
    joined_community.save
    joining_user = User.new(name:'name:aaaa_participant')
    joining_user.save

    joined_community.participants << joining_user
    refute_nil joined_community.participants, 'failure of relation between community and participant'
  end
  
end
