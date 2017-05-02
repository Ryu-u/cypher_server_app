require 'test_helper'

class CypherTest < ActiveSupport::TestCase
  test 'relation between community and cypher' do
    community = Community.create(name:'aaaa-community')
    cypher = Cypher.create(name:'aaaa-cypher')

    cypher.community = community

    refute_nil community.cyphers, 'failure of relation between community and cyphers'
  end
end
