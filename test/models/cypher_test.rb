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
    host = User.create(name:'aaaa-host')
    participant = User.create(name:'aaaa-participant')
    cypher = Cypher.new(name:'aaaa-cypher')

    cypher.community = community
    cypher.host = host
    cypher.save

    cypher.participants << participant = User.create(name:'aaaa-participant')

    assert_not cypher.empty?, 'failure of relation between cypher and host'
  end

  test 'relation between cypher and participant' do

  end