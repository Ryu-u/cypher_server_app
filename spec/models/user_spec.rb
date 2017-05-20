require 'rails_helper'

describe User do
  describe 'with DB' do
    context 'not null constraint' do
      it { have_not_null_constraint_on(:name) }
      it { have_not_null_constraint_on(:home) }
      it { have_not_null_constraint_on(:bio) }
      it { have_not_null_constraint_on(:type_flag) }
    end
  end

  describe 'with model' do
    context 'validation' do
      describe ' of presence' do
        it { is_expected.to validate_presence_of(:name) }
        it { is_expected.to validate_presence_of(:home) }
        it { is_expected.to validate_presence_of(:bio) }
        it { is_expected.to validate_presence_of(:type_flag) }
      end
    end

    context 'association' do
      it { is_expected.to have_many(:community_hosts) }
      it { is_expected.to have_many(:hosting_communities).through(:community_hosts) }
      it { is_expected.to have_many(:community_participants) }
      it { is_expected.to have_many(:participating_communities).through(:community_participants) }
      it { is_expected.to have_many(:community_followers) }
      it { is_expected.to have_many(:following_communities).through(:community_followers) }
      it { is_expected.to have_many(:hosting_cyphers)}
      it { is_expected.to have_many(:cypher_participants) }
      it { is_expected.to have_many(:participating_cyphers).through(:cypher_participants) }
      it { is_expected.to have_many(:posts)}
    end
  end
end