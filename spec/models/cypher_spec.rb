require 'rails_helper'

describe Cypher do
  describe 'with DB' do
    it {have_not_null_constraint_on(:name)}
    it {have_not_null_constraint_on(:serial_num)}
    it {have_not_null_constraint_on(:community_id)}
    it {have_not_null_constraint_on(:info)}
    it {have_not_null_constraint_on(:cypher_from)}
    it {have_not_null_constraint_on(:cypher_to)}
    it {have_not_null_constraint_on(:place)}
    it {have_not_null_constraint_on(:host_id)}
  end

  describe 'with validation' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:serial_num) }
    it { is_expected.to validate_presence_of(:community_id) }
    it { is_expected.to validate_presence_of(:info) }
    it { is_expected.to validate_presence_of(:cypher_from) }
    it { is_expected.to validate_presence_of(:cypher_to) }
    it { is_expected.to validate_presence_of(:place) }
    it { is_expected.to validate_presence_of(:host_id) }
  end
end