require 'rails_helper'

describe Post do
  describe 'with DB' do
    context 'not null constraint' do
      it {have_not_null_constraint_on(:user_id)}
      it {have_not_null_constraint_on(:cypher_id)}
    end
  end

  describe 'with model' do
    context 'validation' do
      describe 'of presence' do
        it { is_expected.to validate_presence_of(:cypher_id) }
        it { is_expected.to validate_presence_of(:user_id) }
      end
    end

    context 'association' do
      it {is_expected.to belong_to(:cypher)}
      it {is_expected.to belong_to(:user)}
    end
  end
end
