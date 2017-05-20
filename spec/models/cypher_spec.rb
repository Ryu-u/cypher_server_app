require 'rails_helper'

describe Cypher do
  describe 'with DB' do
    context 'not null constraint' do
      it {have_not_null_constraint_on(:name)}
      it {have_not_null_constraint_on(:serial_num)}
      it {have_not_null_constraint_on(:community_id)}
      it {have_not_null_constraint_on(:info)}
      it {have_not_null_constraint_on(:cypher_from)}
      it {have_not_null_constraint_on(:cypher_to)}
      it {have_not_null_constraint_on(:place)}
      it {have_not_null_constraint_on(:host_id)}
    end
  end

  describe 'with model' do
    context 'validation' do
      it { is_expected.to validate_presence_of(:name) }
      it { is_expected.to validate_presence_of(:serial_num) }
      it { is_expected.to validate_presence_of(:community_id) }
      it { is_expected.to validate_presence_of(:info) }
      it { is_expected.to validate_presence_of(:cypher_from) }
      it { is_expected.to validate_presence_of(:cypher_to) }
      it { is_expected.to validate_presence_of(:place) }
      it { is_expected.to validate_presence_of(:host_id) }
    end

    context 'association' do
      it{ is_expected.to belong_to(:community) }
      it{ is_expected.to belong_to(:host) }
      it{ is_expected.to have_many(:cypher_participants) }
      it{ is_expected.to have_many(:participants).through(:cypher_participants) }
      it{ is_expected.to have_many(:posts) }
      it{ is_expected.to have_many(:cypher_tags) }
      it{ is_expected.to have_many(:tags).through(:cypher_tags) }
    end
  end
end