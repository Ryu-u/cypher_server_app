require 'rails_helper'

describe CypherParticipant do
  describe 'with DB' do
    context 'not null constraint' do
      it {have_not_null_constraint_on(:cypher_id)}
      it {have_not_null_constraint_on(:participant_id)}
    end

    context 'of index' do
      it 'should not have two records whith have the same combination of cypher_id and participant_id' do
        expect do
          community = Community.create(name: "aaaa", home: "aaaa", bio: "aaaa")
          host = User.create(name: "aaaa", home: "aaaa", bio: "aaaa", type_flag:1)
          community.hosts << host
          community.save
          cypher = Cypher.new(name: "aaaa",
                              serial_num:1,
                              info:"aaaa",
                              cypher_from:DateTime.now(),
                              cypher_to:DateTime.now(),
                              place:"aaaa")
          cypher.community = community
          cypher.host = host
          cypher.save

          participant = User.create(name: "bbbb",
                                    home: "bbbb",
                                    bio: "bbbb",
                                    type_flag:1)
          cypher.participants << participant
          cypher.save

          cypher_participant = CypherParticipant.new(cypher_id: cypher.id,
                                                     participant_id: participant.id)
          cypher_participant.save!(validate: false)
        end.to raise_error(ActiveRecord::RecordNotUnique)
      end
    end
  end

  describe 'with model' do
    context 'validation' do
      describe 'of presence' do
        it { is_expected.to validate_presence_of(:cypher_id) }
        it { is_expected.to validate_presence_of(:participant_id) }
      end

      describe 'of uniqueness' do
        subject{CypherParticipant.new(cypher_id:1, participant_id:1)}
        it { is_expected.to validate_uniqueness_of(:cypher_id).scoped_to(:participant_id) }
      end
    end

    context 'association' do
      it{is_expected.to belong_to(:cypher)}
      it{is_expected.to belong_to(:participant)}
    end
  end

end