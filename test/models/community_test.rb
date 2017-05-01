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
end
