require 'rails_helper'

RSpec.describe "Communities", type: :request do
  before do
    @community = create(:community,
                        :with_host,
                        :with_participant,
                        :with_follower,
                        :with_cypher,
                        :with_regular_cypher,
                        :with_tag)
    @past_cyphers = @community.cyphers.
                                where('cypher_from < ?', Date.today.to_datetime).
                                order(cypher_from: :desc).all
    @future_cyphers = @community.cyphers.
                                  where('cypher_from >= ?', Date.today.to_datetime).
                                  order(:cypher_from).all
  end

  describe 'return status' do
    it 'return 200 OK' do
      get "/api/v1/communities/#{@community.id}"
      expect(response.status).to eq(200)
    end
  end

  # User型については、ここでは内容の一致はidのみに留める。
  # 詳細な内容の一致については、User型のテスト内で実施
  # CypherSummary型を使うものについても同様
  describe 'response of community' do
    it 'matches the data-type pattern' do
      pattern = {
          community: {
              id:               Integer,
              name:             String,
              home:             String,
              bio:              String,
              twitter_account:  String,
              facebook_account: String,
              thumbnail_url:    String,
              tags: [
                  {
                      id:      Integer,
                      content: String
                  }
              ].ignore_extra_values!,
              hosts: [
                  {
                      id:                             Integer,
                      name:                           String,
                      home:                           String,
                      bio:                            String,
                      type_flag:                      Integer,
                      twitter_account:                String,
                      facebook_account:               String,
                      participating_cyphers:          [],
                      participating_communities:      [],
                      thumbnail_url:                  String
                  }
              ].ignore_extra_values!,
              members: [
                  {
                      id:                             Integer,
                      name:                           String,
                      home:                           String,
                      bio:                            String,
                      type_flag:                      Integer,
                      twitter_account:                String,
                      facebook_account:               String,
                      participating_cyphers:          [],
                      participating_communities:      Array,
                      thumbnail_url:                  String
                  }
              ].ignore_extra_values!,
              regular_cypher: {
                      place:              String,
                      cypher_day:         Integer,
                      cypher_from:        String,
                      cypher_to:          String
              },
              past_cyphers: [
                  {
                      id:                 Integer,
                      name:               String,
                      serial_num:         Integer,
                      cypher_from:        String,
                      cypher_to:          String,
                      capacity:           Integer,
                      thumbnail_url:      String
                  }
              ].ignore_extra_values!,
              future_cyphers: [
                  {
                      id:                 Integer,
                      name:               String,
                      serial_num:         Integer,
                      cypher_from:        String,
                      cypher_to:          String,
                      capacity:           Integer,
                      thumbnail_url:      String
                  }
              ].ignore_extra_values!
          }
      }
      get "/api/v1/communities/#{@community.id}"
      expect(response.body).to match_json_expression(pattern)
    end

    it 'matches the data-content pattern' do
      pattern = {
          community: {
              id:               @community.id,
              name:             @community.name,
              home:             @community.home,
              bio:              @community.bio,
              twitter_account:  @community.twitter_account,
              facebook_account: @community.facebook_account,
              thumbnail_url:    @community.thumbnail,
              tags: [
                  {
                      id:           @community.tags[0].id,
                      content:      @community.tags[0].content
                  },
                  {
                      id:           @community.tags[1].id,
                      content:      @community.tags[1].content
                  },
                  {
                      id:           @community.tags[2].id,
                      content:      @community.tags[2].content
                  }
              ].unordered!,
              hosts: [
                  {
                      id:                             @community.hosts.first.id,
                      name:                           String,
                      home:                           String,
                      bio:                            String,
                      type_flag:                      Integer,
                      twitter_account:                String,
                      facebook_account:               String,
                      participating_cyphers:          [],
                      participating_communities:      [],
                      thumbnail_url:                  String
                  }
              ].ignore_extra_values!,
              members: [
                  {
                      id:                             @community.participants[0].id,
                      name:                           String,
                      home:                           String,
                      bio:                            String,
                      type_flag:                      Integer,
                      twitter_account:                String,
                      facebook_account:               String,
                      participating_cyphers:          [],
                      participating_communities:      Array,
                      thumbnail_url:                  String
                  },
                  {
                      id:                             @community.participants[1].id,
                      name:                           String,
                      home:                           String,
                      bio:                            String,
                      type_flag:                      Integer,
                      twitter_account:                String,
                      facebook_account:               String,
                      participating_cyphers:          [],
                      participating_communities:      Array,
                      thumbnail_url:                  String
                  },
                  {
                      id:                             @community.participants[2].id,
                      name:                           String,
                      home:                           String,
                      bio:                            String,
                      type_flag:                      Integer,
                      twitter_account:                String,
                      facebook_account:               String,
                      participating_cyphers:          [],
                      participating_communities:      Array,
                      thumbnail_url:                  String
                  }
              ].unordered!,
              regular_cypher: {
                  place:              @community.regular_cypher.place,
                  cypher_day:         @community.regular_cypher.cypher_day,
                  cypher_from:        @community.regular_cypher.cypher_from,
                  cypher_to:          @community.regular_cypher.cypher_to
              },
              past_cyphers: [
                  {
                      id:                 @past_cyphers[0].id,
                      name:               String,
                      serial_num:         Integer,
                      cypher_from:        String,
                      cypher_to:          String,
                      capacity:           Integer,
                      thumbnail_url:      String
                  },
                  {
                      id:                 @past_cyphers[1].id,
                      name:               String,
                      serial_num:         Integer,
                      cypher_from:        String,
                      cypher_to:          String,
                      capacity:           Integer,
                      thumbnail_url:      String
                  }
              ].ordered!,
              future_cyphers: [
                  {
                      id:                 @future_cyphers[0].id,
                      name:               String,
                      serial_num:         Integer,
                      cypher_from:        String,
                      cypher_to:          String,
                      capacity:           Integer,
                      thumbnail_url:      String
                  },
                  {
                      id:                 @future_cyphers[1].id,
                      name:               String,
                      serial_num:         Integer,
                      cypher_from:        String,
                      cypher_to:          String,
                      capacity:           Integer,
                      thumbnail_url:      String
                  },
                  {
                      id:                 @future_cyphers[2].id,
                      name:               String,
                      serial_num:         Integer,
                      cypher_from:        String,
                      cypher_to:          String,
                      capacity:           Integer,
                      thumbnail_url:      String
                  }
              ].ordered!
          }
      }
      get "/api/v1/communities/#{@community.id}"
      expect(response.body).to match_json_expression(pattern)
    end
  end

  describe 'error hundling' do
    it 'cannot find the community' do
      get "/api/v1/communities/123456789"
      expect(response.status).to eq(404)
    end

    it 'parameter invalid' do
      get "/api/v1/communities/aaa"
      expect(response.status).to eq(400)
    end

    it 'invalid route error' do
      get "/api/v1/community/1"
      expect(response.status).to eq(500)
    end
  end

end
