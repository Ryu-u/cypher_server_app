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
    @current_user = create(:user, :with_api_key)
    @headers = {'Access-Token' => @current_user.api_keys.last.access_token}
  end

  describe 'return status' do
    it 'return 200 OK' do
      get "/api/v1/communities/#{@community.id}", headers: @headers
      expect(response.status).to eq(200)
    end
  end
  # TODO regular_cypher 変更
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
              hosts:            Array,
              members:          Array,
              regular_cypher: {
                      place:              String,
                      cypher_day:         Integer,
                      cypher_from:        String,
                      cypher_to:          String
              },
              past_cyphers:     Array,
              future_cyphers:   Array
          }
      }
      get "/api/v1/communities/#{@community.id}", headers: @headers
      expect(response.body).to match_json_expression(pattern)
    end
    # TODO regular_cypher 変更
    it 'matches the data-content pattern' do
      pattern = {
          community: {
              id:               @community.id,
              name:             @community.name,
              home:             @community.home,
              bio:              @community.bio,
              twitter_account:  @community.twitter_account,
              facebook_account: @community.facebook_account,
              thumbnail_url:    @community.thumbnail.url,
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
                  }.ignore_extra_keys!
              ].ignore_extra_values!,
              members: [
                  {
                      id:                             @community.participants[0].id,
                  }.ignore_extra_keys!,
                  {
                      id:                             @community.participants[1].id,
                  }.ignore_extra_keys!,
                  {
                      id:                             @community.participants[2].id,
                  }.ignore_extra_keys!
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
                  }.ignore_extra_keys!,
                  {
                      id:                 @past_cyphers[1].id,
                  }.ignore_extra_keys!
              ].ordered!,
              future_cyphers: [
                  {
                      id:                 @future_cyphers[0].id,
                  }.ignore_extra_keys!,
                  {
                      id:                 @future_cyphers[1].id,
                  }.ignore_extra_keys!,
                  {
                      id:                 @future_cyphers[2].id,
                  }.ignore_extra_keys!
              ].ordered!
          }
      }
      get "/api/v1/communities/#{@community.id}", headers: @headers
      expect(response.body).to match_json_expression(pattern)
    end
  end

  describe 'error hundling' do
    it 'cannot find the community' do
      get "/api/v1/communities/123456789", headers: @headers
      expect(response.status).to eq(404)
    end

    it 'parameter invalid' do
      get "/api/v1/communities/aaa", headers: @headers
      expect(response.status).to eq(400)
    end

    it 'invalid route error' do
      get "/api/v1/community/1", headers: @headers
      expect(response.status).to eq(500)
    end
  end

  describe 'get /my_communities' do
    before do
      unless RSpec.current_example.metadata[:skipbefore]
        @current_user = create(:user, :with_api_key)
        @headers = {'Access-Token' => @current_user.api_keys.last.access_token}
        @community = create(:community)
      end
    end
    context 'normal' do
      it 'return 200' do
        @community.participants << @current_user
        get '/api/v1/my_communities?since_id=0', headers: @headers
        expect(response.status).to eq(200)
      end

      it 'matches data-type pattern' do
        pattern = {
            communities: [
                {
                    id:             Integer,
                    name:           String,
                    thumbnail_url:  String,
                    next_cyphers:    Array
                }
            ].ignore_extra_values!,

            total:           Integer
        }
        @community.participants << @current_user
        get '/api/v1/my_communities?since_id=0', headers: @headers
        expect(response.body).to match_json_expression(pattern)
      end

      it 'matches data-content pattern' do
        @community.participants << @current_user
        get '/api/v1/my_communities?since_id=0', headers: @headers
        pattern = {
            communities: [
                {
                    id:             @community.id,
                    name:           @community.name,
                    thumbnail_url:  @community.thumbnail.url,
                    next_cyphers:    Array
                }

            ].ignore_extra_values!,
            total:        @current_user.participating_communities.count
        }
        expect(response.body).to match_json_expression(pattern)
      end

      it 'order correctly' do
        3.times do
          community = create(:community)
          community.participants << @current_user
        end
        all_communities = @current_user.participating_communities.
            joins(:community_participants).
            includes(:community_participants).
            ordering{|community| [community.community_participants.created_at.desc, community.id.asc]}
        pattern = {
            communities: [
                {
                    id:     all_communities[0].id
                }.ignore_extra_keys!,
                {
                    id:     all_communities[1].id
                }.ignore_extra_keys!,
                {
                    id:     all_communities[2].id
                }.ignore_extra_keys!
            ],
            total:        all_communities.count
        }
        get '/api/v1/my_communities?since_id=1', headers: @headers
        expect(response.body).to match_json_expression(pattern)
      end

      it 'paginate correctly', skipbefore: true do
        25.times do
          community = create(:community)
          community.participants << @current_user
        end
        all_communities = @current_user.participating_communities.
                                        joins(:community_participants).
                                        includes(:community_participants).
                                        order("communities.id ASC")
        pattern1 = {
            communities: [
                {id:     all_communities[0].id}.ignore_extra_keys!,
                {id:     all_communities[1].id}.ignore_extra_keys!,
                {id:     all_communities[2].id}.ignore_extra_keys!,
                {id:     all_communities[3].id}.ignore_extra_keys!,
                {id:     all_communities[4].id}.ignore_extra_keys!,
                {id:     all_communities[5].id}.ignore_extra_keys!,
                {id:     all_communities[6].id}.ignore_extra_keys!,
                {id:     all_communities[7].id}.ignore_extra_keys!,
                {id:     all_communities[8].id}.ignore_extra_keys!,
                {id:     all_communities[9].id}.ignore_extra_keys!,
                {id:     all_communities[10].id}.ignore_extra_keys!,
                {id:     all_communities[11].id}.ignore_extra_keys!,
                {id:     all_communities[12].id}.ignore_extra_keys!,
                {id:     all_communities[13].id}.ignore_extra_keys!,
                {id:     all_communities[14].id}.ignore_extra_keys!,
                {id:     all_communities[15].id}.ignore_extra_keys!,
                {id:     all_communities[16].id}.ignore_extra_keys!,
                {id:     all_communities[17].id}.ignore_extra_keys!,
                {id:     all_communities[18].id}.ignore_extra_keys!,
                {id:     all_communities[19].id}.ignore_extra_keys!
            ],
            total:        25
        }

        pattern2 = {
            communities: [
                {id:     all_communities[20].id}.ignore_extra_keys!,
                {id:     all_communities[21].id}.ignore_extra_keys!,
                {id:     all_communities[22].id}.ignore_extra_keys!,
                {id:     all_communities[23].id}.ignore_extra_keys!,
                {id:     all_communities[24].id}.ignore_extra_keys!
            ],
            total:        25
        }
        get '/api/v1/my_communities?since_id=0', headers: @headers
        expect(response.body).to match_json_expression(pattern1)

        get "/api/v1/my_communities?since_id=#{all_communities[19].id}", headers: @headers
        expect(response.body).to match_json_expression(pattern2)
      end

      it 'return empty array' do
        get '/api/v1/my_communities?since_id=9999', headers: @headers
        pattern ={
            communities: [],
            total:       0
        }
        expect(response.body).to match_json_expression(pattern)
      end
    end

    context 'abnormal' do
      describe 'miss since_id ' do
        it 'return 400' do
          get '/api/v1/my_communities', headers: @headers
          expect(response.status).to eq(400)
        end
      end

      describe 'wrong type of since_id' do
        it 'return 400' do
          get '/api/v1/my_communities?since_id=a', headers: @headers
          expect(response.status).to eq(400)
        end
      end
    end
  end

  describe 'get /hosting_communities' do
    before do
      unless RSpec.current_example.metadata[:skipbefore]
        @current_user = create(:user, :with_api_key)
        @headers = {'Access-Token' => @current_user.api_keys.last.access_token}
        @community = create(:community)
      end
    end
    context 'normal' do
      it 'return 200' do
        @community.hosts << @current_user
        get '/api/v1/hosting_communities?since_id=0', headers: @headers
        expect(response.status).to eq(200)
      end

      it 'matches data-type pattern' do
        pattern = {
            communities: [
                {
                    id:             Integer,
                    name:           String,
                    thumbnail_url:  String,
                    next_cyphers:    Array
                }
            ].ignore_extra_values!,

            total:           Integer
        }
        @community.hosts << @current_user
        get '/api/v1/hosting_communities?since_id=0', headers: @headers
        expect(response.body).to match_json_expression(pattern)
      end

      it 'matches data-content pattern' do
      @community.hosts << @current_user
      get '/api/v1/hosting_communities?since_id=0', headers: @headers
        pattern = {
            communities: [
                {
                    id:             @community.id,
                    name:           @community.name,
                    thumbnail_url:  @community.thumbnail.url,
                    next_cyphers:    Array
                }

            ].ignore_extra_values!,
            total:        @current_user.hosting_communities.count
        }
        expect(response.body).to match_json_expression(pattern)
      end

      it 'order correctly' do
        3.times do
          community = create(:community)
          community.hosts << @current_user
        end
        all_communities = @current_user.hosting_communities.
                                        joins(:community_hosts).
                                        includes(:community_hosts).
                                        order("communities.id ASC")
        pattern = {
            communities: [
                {id:     all_communities[0].id}.ignore_extra_keys!,
                {id:     all_communities[1].id}.ignore_extra_keys!,
                {id:     all_communities[2].id}.ignore_extra_keys!
            ],
            total:        all_communities.count
        }
        get '/api/v1/hosting_communities?since_id=0', headers: @headers
        expect(response.body).to match_json_expression(pattern)
      end

      it 'paginate correctly', skipbefore: true do
        25.times do
          community = create(:community)
          community.hosts << @current_user
        end
        all_communities = @current_user.hosting_communities.
                                        order("communities.id ASC")

        pattern1 = {
            communities: [
                {id:     all_communities[0].id}.ignore_extra_keys!,
                {id:     all_communities[1].id}.ignore_extra_keys!,
                {id:     all_communities[2].id}.ignore_extra_keys!,
                {id:     all_communities[3].id}.ignore_extra_keys!,
                {id:     all_communities[4].id}.ignore_extra_keys!,
                {id:     all_communities[5].id}.ignore_extra_keys!,
                {id:     all_communities[6].id}.ignore_extra_keys!,
                {id:     all_communities[7].id}.ignore_extra_keys!,
                {id:     all_communities[8].id}.ignore_extra_keys!,
                {id:     all_communities[9].id}.ignore_extra_keys!,
                {id:     all_communities[10].id}.ignore_extra_keys!,
                {id:     all_communities[11].id}.ignore_extra_keys!,
                {id:     all_communities[12].id}.ignore_extra_keys!,
                {id:     all_communities[13].id}.ignore_extra_keys!,
                {id:     all_communities[14].id}.ignore_extra_keys!,
                {id:     all_communities[15].id}.ignore_extra_keys!,
                {id:     all_communities[16].id}.ignore_extra_keys!,
                {id:     all_communities[17].id}.ignore_extra_keys!,
                {id:     all_communities[18].id}.ignore_extra_keys!,
                {id:     all_communities[19].id}.ignore_extra_keys!
            ],
            total:        25
        }

        pattern2 = {
            communities: [
                {id:     all_communities[20].id}.ignore_extra_keys!,
                {id:     all_communities[21].id}.ignore_extra_keys!,
                {id:     all_communities[22].id}.ignore_extra_keys!,
                {id:     all_communities[23].id}.ignore_extra_keys!,
                {id:     all_communities[24].id}.ignore_extra_keys!
            ],
            total:        25
        }
        get '/api/v1/hosting_communities?since_id=0', headers: @headers
        expect(response.body).to match_json_expression(pattern1)

        get "/api/v1/hosting_communities?since_id=#{all_communities[19].id}", headers: @headers
        expect(response.body).to match_json_expression(pattern2)
      end
    end

    context 'abnormal' do
      describe 'miss since_id ' do
        it 'return 400' do
          get '/api/v1/hosting_communities', headers: @headers
          expect(response.status).to eq(400)
        end
      end

      describe 'wrong type of since_id' do
        it 'return 400' do
          get '/api/v1/hosting_communities?since_id=a', headers: @headers
          expect(response.status).to eq(400)
        end
      end
    end
  end

  describe 'get /following_communities' do
    before do
      unless RSpec.current_example.metadata[:skipbefore]
        @current_user = create(:user, :with_api_key)
        @headers = {'Access-Token' => @current_user.api_keys.last.access_token}
        @community = create(:community)
      end
    end
    context 'normal' do
      it 'return 200' do
        @community.followers << @current_user
        get '/api/v1/following_communities?since_id=0', headers: @headers
        expect(response.status).to eq(200)
      end

      it 'matches data-type pattern' do
        pattern = {
            communities: [
                {
                    id:             Integer,
                    name:           String,
                    thumbnail_url:  String,
                    next_cyphers:    Array
                }
            ].ignore_extra_values!,

            total:           Integer
        }
        @community.followers << @current_user
        get '/api/v1/following_communities?since_id=0', headers: @headers
        expect(response.body).to match_json_expression(pattern)
      end

      it 'matches data-content pattern' do
        @community.followers << @current_user
        get '/api/v1/following_communities?since_id=0', headers: @headers
        pattern = {
            communities: [
                {
                    id:             @community.id,
                    name:           @community.name,
                    thumbnail_url:  @community.thumbnail.url,
                    next_cyphers:    Array
                }

            ].ignore_extra_values!,
            total:        @current_user.following_communities.count
        }
        expect(response.body).to match_json_expression(pattern)
      end

      it 'order correctly', skipbefore: true do
        3.times do
          community = create(:community)
          community.followers << @current_user
        end
        all_communities = @current_user.following_communities.
                                        joins(:community_followers).
                                        includes(:community_followers).
                                        order("communities.id ASC")
        pattern = {
            communities: [
                {id:     all_communities[0].id}.ignore_extra_keys!,
                {id:     all_communities[1].id}.ignore_extra_keys!,
                {id:     all_communities[2].id}.ignore_extra_keys!
            ],
            total:        all_communities.count
        }
        get '/api/v1/following_communities?since_id=1', headers: @headers
        expect(response.body).to match_json_expression(pattern)
      end

      it 'paginate correctly', skipbefore: true do
        25.times do
          community = create(:community)
          community.followers << @current_user
        end
        all_communities = @current_user.following_communities.
                                        joins(:community_followers).
                                        includes(:community_followers).
                                        order("communities.id ASC")

        pattern1 = {
            communities: [
                {id:     all_communities[0].id}.ignore_extra_keys!,
                {id:     all_communities[1].id}.ignore_extra_keys!,
                {id:     all_communities[2].id}.ignore_extra_keys!,
                {id:     all_communities[3].id}.ignore_extra_keys!,
                {id:     all_communities[4].id}.ignore_extra_keys!,
                {id:     all_communities[5].id}.ignore_extra_keys!,
                {id:     all_communities[6].id}.ignore_extra_keys!,
                {id:     all_communities[7].id}.ignore_extra_keys!,
                {id:     all_communities[8].id}.ignore_extra_keys!,
                {id:     all_communities[9].id}.ignore_extra_keys!,
                {id:     all_communities[10].id}.ignore_extra_keys!,
                {id:     all_communities[11].id}.ignore_extra_keys!,
                {id:     all_communities[12].id}.ignore_extra_keys!,
                {id:     all_communities[13].id}.ignore_extra_keys!,
                {id:     all_communities[14].id}.ignore_extra_keys!,
                {id:     all_communities[15].id}.ignore_extra_keys!,
                {id:     all_communities[16].id}.ignore_extra_keys!,
                {id:     all_communities[17].id}.ignore_extra_keys!,
                {id:     all_communities[18].id}.ignore_extra_keys!,
                {id:     all_communities[19].id}.ignore_extra_keys!
            ],
            total:        25
        }

        pattern2 = {
            communities: [
                {id:     all_communities[20].id}.ignore_extra_keys!,
                {id:     all_communities[21].id}.ignore_extra_keys!,
                {id:     all_communities[22].id}.ignore_extra_keys!,
                {id:     all_communities[23].id}.ignore_extra_keys!,
                {id:     all_communities[24].id}.ignore_extra_keys!
            ],
            total:        25
        }
        get '/api/v1/following_communities?since_id=0', headers: @headers
        expect(response.body).to match_json_expression(pattern1)

        get "/api/v1/following_communities?since_id=#{all_communities[19].id}", headers: @headers
        expect(response.body).to match_json_expression(pattern2)
      end

      it 'return empty array' do
        get '/api/v1/following_communities?since_id=0', headers: @headers
        pattern ={
            communities: [],
            total:       0
        }
        expect(response.body).to match_json_expression(pattern)
      end
    end

    context 'abnormal' do
      describe 'miss since_id ' do
        it 'return 400' do
          get '/api/v1/following_communities', headers: @headers
          expect(response.status).to eq(400)
        end
      end

      describe 'wrong type of since_id' do
        it 'return 400' do
          get '/api/v1/following_communities?since_id=a', headers: @headers
          expect(response.status).to eq(400)
        end
      end
    end
  end
end