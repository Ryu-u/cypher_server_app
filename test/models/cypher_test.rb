require 'test_helper'

class CypherTest < ActiveSupport::TestCase
  test 'relation between community and cypher' do
    community = Community.create(name:'aaaa-community')
    cypher = Cypher.create(name:'aaaa-cypher')

    cypher.community = community

    community.cyphers << cypher
    refute_nil community.cyphers, 'failure of relation between community and cyphers'
  end

  test 'relation between cypher and host' do
    community = Community.create(name:'aaaa-community')
    cypher = Cypher.create(name:'aaaa-cypher')

    cypher.community = community

    host = User.create(name:'aaaa-host')
    community.hosts << host
    cypher.host = host
    refute_nil cypher.host, 'failure of relation between cypher and host'
  end
end
