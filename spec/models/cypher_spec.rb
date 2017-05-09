require 'rails_helper'

describe Cypher do

  it {have_not_null_constraint_on(:name)}
  it {have_not_null_constraint_on(:serial_num)}
  it {have_not_null_constraint_on(:community_id)}
  it {have_not_null_constraint_on(:info)}
  it {have_not_null_constraint_on(:cypher_from)}
  it {have_not_null_constraint_on(:cypher_to)}
  it {have_not_null_constraint_on(:place)}
  it {have_not_null_constraint_on(:host_id)}

end