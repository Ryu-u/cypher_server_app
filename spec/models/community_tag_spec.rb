require 'rails_helper'

describe CommunityTag do
  describe 'with DB' do
    context 'not null constraint' do
      it {have_not_null_constraint_on(:community_id)}
      it {have_not_null_constraint_on(:tag_id)}
    end

    context 'of uniqueness' do
      it 'should not have the same combination of community_id and tag_id in different records' do
        community = create(:community)
        tag = create(:tag)
        community.tags << tag
        community_tags = CommunityTag.new

        expect do
          community_tags.community_id = community.id
          community_tags.tag_id = tag.id
          community_tags.save!(validate: false)
        end.to raise_error(ActiveRecord::RecordNotUnique)
      end
    end
  end

  describe ' with model' do
    context 'validation' do
      describe 'presence' do
        it{ is_expected.to validate_presence_of(:community_id) }
        it{ is_expected.to validate_presence_of(:tag_id) }
      end

      describe 'uniqueness' do
        subject{CommunityTag.new(community_id: 1, tag_id: 1)}
        it{is_expected.to validate_uniqueness_of(:community_id).scoped_to(:tag_id)}
      end
    end

    context 'association' do
      it{is_expected.to belong_to(:community)}
      it{is_expected.to belong_to(:tag)}
    end
  end
end
