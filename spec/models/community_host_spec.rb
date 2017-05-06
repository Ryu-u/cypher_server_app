require 'rails_helper'

describe CommunityHost do

  it {have_not_null_constraint_on(:community_id)}
  it {have_not_null_constraint_on(:host_id)}

end