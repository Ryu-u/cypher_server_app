require 'rails_helper'

describe CommunityHost do
  describe 'with DB' do
    context 'not null constraint' do
      it {have_not_null_constraint_on(:community_id)}
      it {have_not_null_constraint_on(:host_id)}
    end

    context 'of index' do
      it 'should not have two records which have the same combination of community_id and host id' do
        expect do
          # あらかじめコミュニティとホストを作成
          community = create(:community)
          host = create(:host)
          community.hosts << host
          community.save

          #　重複するレコードを作成
          community_host = CommunityHost.new(community_id: community.id,
                                             host_id: host.id)
          community_host.save!(validate: false)
        end.to raise_error(ActiveRecord::RecordNotUnique)
      end
    end
  end

  describe 'with model' do
    context 'of presence' do
      it { is_expected.to validate_presence_of(:community_id) }
      it { is_expected.to validate_presence_of(:host_id) }
    end

    context 'of uniqueness' do
      subject{CommunityHost.new(community_id:1, host_id:1)}
      it { is_expected.to validate_uniqueness_of(:community_id).scoped_to(:host_id) }
    end

    context 'association' do
      it {is_expected.to belong_to(:hosting_community)}
      it {is_expected.to belong_to(:host)}
    end
  end
end