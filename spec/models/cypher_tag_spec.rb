require 'rails_helper'

describe CypherTag do
  describe 'with DB' do
    context 'not null constraint' do
      it {have_not_null_constraint_on(:cypher_id)}
      it {have_not_null_constraint_on(:tag_id)}
    end

    context 'of uniqueness' do
      it 'should not have the same combination of cypher_id and tag_id in different records' do
        community = create(:community)
        host = create(:user)
        cypher = build(:cypher)
        cypher.community = community
        cypher.host = host
        cypher.save

        tag = create(:tag)
        cypher.tags << tag

        another_tag = build(:cypher_tag)

        expect do
          another_tag.cypher_id = cypher.id
          another_tag.tag_id = tag.id
          another_tag.save!(validate: false)
        end.to raise_error(ActiveRecord::RecordNotUnique)
      end
    end
  end

  describe 'with model' do
    context 'validation' do
      describe 'presence' do
        it {is_expected.to validate_presence_of(:cypher_id)}
        it {is_expected.to validate_presence_of(:tag_id)}
      end

      describe 'uniqueness' do
        subject{CypherTag.new(cypher_id:1, tag_id:1)}
        it{is_expected.to validate_uniqueness_of(:cypher_id).scoped_to(:tag_id)}
      end
    end

    context 'association' do
      it{is_expected.to belong_to(:cypher)}
      it{is_expected.to belong_to(:tag)}
    end
  end
end
