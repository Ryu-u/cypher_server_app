require 'rails_helper'

describe Cypher do

  it {have_not_null_constraint_on(:cypher_id)}
  it {have_not_null_constraint_on(:participant_id)}

end