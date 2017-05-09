require 'rails_helper'

describe CommunityTag do
  it {have_not_null_constraint_on(:community_id)}
  it {have_not_null_constraint_on(:tag_id)}
end
