require 'rails_helper'

describe CommunityParticipant do

  it {have_not_null_constraint_on(:community_id)}
  it {have_not_null_constraint_on(:participant_id)}

end