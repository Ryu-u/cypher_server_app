require 'rails_helper'

describe CommunityHost do
  before do
    @community = create(:community)
    @host = create(:user)
    @community.hosts << @host
  end

  it 'community_id column should not be null' do
    expect{@community.community_hosts.update(community_id: nil)}.to raise_error
  end

  it 'host_id column should not be null' do
    expect{@community.community_hosts.update(host_id: nil)}.to raise_error
  end
end