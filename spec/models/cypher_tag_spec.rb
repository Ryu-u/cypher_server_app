require 'rails_helper'

describe CypherTag do
  it {have_not_null_constraint_on(:cypher_id)}
  it {have_not_null_constraint_on(:tag_id)}
end
