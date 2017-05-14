require 'rails_helper'

describe CommunityParticipant do
  describe 'with DB' do
    it {have_not_null_constraint_on(:community_id)}
    it {have_not_null_constraint_on(:participant_id)}

    describe 'of index' do
      it 'should not have two records whith have the same combination of community_id and participant id' do
        expect do
          community = Community.create(name: "aaaa", home: "aaaa", bio: "aaaa")
          participant = User.create(name: "aaaa", home: "aaaa", bio: "aaaa", type_flag:1)
          community.participants << participant
          community.save
          community_participant = CommunityParticipant.new(community_id: community.id, participant_id: participant.id)
          community_participant.save!(validate: false)
        end.to raise_error(ActiveRecord::RecordNotUnique)
      end
    end
  end

  describe 'with validation' do
    it { is_expected.to validate_presence_of(:community_id) }
    it { is_expected.to validate_presence_of(:participant_id) }

    describe 'of uniqueness' do
      subject{CommunityParticipant.new(community_id:1, participant_id:1)}
      it { is_expected.to validate_uniqueness_of(:community_id).scoped_to(:participant_id) }
    end
  end
end
