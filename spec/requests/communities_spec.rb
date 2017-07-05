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
                      twitter_account:                String,
                      facebook_account:               String,
                      google_account:                 String,
                      type:{
                          mc_flag:                    Boolean,
                          dj_flag:                    Boolean,
                          trackmaker_flag:            Boolean
                      },
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
                      twitter_account:                String,
                      facebook_account:               String,
                      google_account:                 String,
                      type:{
                          mc_flag:                    Boolean,
                          dj_flag:                    Boolean,
                          trackmaker_flag:            Boolean
                      },
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
      get "/api/v1/communities/#{@community.id}", headers: @headers
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
                      name:                           String,
                      home:                           String,
                      bio:                            String,
                      twitter_account:                String,
                      facebook_account:               String,
                      google_account:                 String,
                      type:{
                          mc_flag:                    Boolean,
                          dj_flag:                    Boolean,
                          trackmaker_flag:            Boolean
                      },
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
                      type:{
                          mc_flag:                    Boolean,
                          dj_flag:                    Boolean,
                          trackmaker_flag:            Boolean
                      },
                      twitter_account:                String,
                      facebook_account:               String,
                      google_account:                 String,
                      participating_cyphers:          [],
                      participating_communities:      Array,
                      thumbnail_url:                  String
                  },
                  {
                      id:                             @community.participants[1].id,
                      name:                           String,
                      home:                           String,
                      bio:                            String,
                      type:{
                          mc_flag:                    Boolean,
                          dj_flag:                    Boolean,
                          trackmaker_flag:            Boolean
                      },
                      twitter_account:                String,
                      facebook_account:               String,
                      google_account:                 String,
                      participating_cyphers:          [],
                      participating_communities:      Array,
                      thumbnail_url:                  String
                  },
                  {
                      id:                             @community.participants[2].id,
                      name:                           String,
                      home:                           String,
                      bio:                            String,
                      type:{
                          mc_flag:                    Boolean,
                          dj_flag:                    Boolean,
                          trackmaker_flag:            Boolean
                      },
                      twitter_account:                String,
                      facebook_account:               String,
                      google_account:                 String,
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
      @current_user = create(:user, :with_api_key)
      @headers = {'Access-Token' => @current_user.api_keys.last.access_token}
      @community = create(:community)
    end
    context 'normal' do
      it 'return 200' do
        @community.participants << @current_user
        get '/api/v1/my_communities?page=1', headers: @headers
        expect(response.status).to eq(200)
      end

      it 'matches data-type pattern' do
        pattern = {
            communities: [
                {
                    id:             Integer,
                    name:           String,
                    thumbnail_url:  String,
                    next_cypher:    Array
                }
            ].ignore_extra_values!,

            total:           Integer,
            current_page:    Integer
        }
        @community.participants << @current_user
        get '/api/v1/my_communities?page=1', headers: @headers
        expect(response.body).to match_json_expression(pattern)
      end

      it 'matches data-content pattern' do
        @community.participants << @current_user
        get '/api/v1/my_communities?page=1', headers: @headers
        pattern = {
            communities: [
                {
                    id:             @community.id,
                    name:           @community.name,
                    thumbnail_url:  @community.thumbnail.url,
                    next_cypher:    Array
                }

            ].ignore_extra_values!,
            total:        @current_user.participating_communities.count,
            current_page:    1
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
            order("community_participants.created_at DESC")
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
            total:        all_communities.count,
            current_page:    1
        }
        get '/api/v1/my_communities?page=1', headers: @headers
        expect(response.body).to match_json_expression(pattern)
      end

      it 'paginate correctly' do
        25.times do
          community = create(:community)
          community.participants << @current_user
        end
        all_communities = @current_user.participating_communities.
            joins(:community_participants).
            includes(:community_participants).
            order("community_participants.created_at DESC")
        pattern1 = {
            communities: [
                {
                    id:     all_communities[0].id
                }.ignore_extra_keys!,
                {
                    id:     all_communities[1].id
                }.ignore_extra_keys!,
                {
                    id:     all_communities[2].id
                }.ignore_extra_keys!,
                {
                    id:     all_communities[3].id
                }.ignore_extra_keys!,
                {
                    id:     all_communities[4].id
                }.ignore_extra_keys!,
                {
                    id:     all_communities[5].id
                }.ignore_extra_keys!,
                {
                    id:     all_communities[6].id
                }.ignore_extra_keys!,
                {
                    id:     all_communities[7].id
                }.ignore_extra_keys!,
                {
                    id:     all_communities[8].id
                }.ignore_extra_keys!,
                {
                    id:     all_communities[9].id
                }.ignore_extra_keys!,
                {
                    id:     all_communities[10].id
                }.ignore_extra_keys!,
                {
                    id:     all_communities[11].id
                }.ignore_extra_keys!,
                {
                    id:     all_communities[12].id
                }.ignore_extra_keys!,
                {
                    id:     all_communities[13].id
                }.ignore_extra_keys!,
                {
                    id:     all_communities[14].id
                }.ignore_extra_keys!,
                {
                    id:     all_communities[15].id
                }.ignore_extra_keys!,
                {
                    id:     all_communities[16].id
                }.ignore_extra_keys!,
                {
                    id:     all_communities[17].id
                }.ignore_extra_keys!,
                {
                    id:     all_communities[18].id
                }.ignore_extra_keys!,
                {
                    id:     all_communities[19].id
                }.ignore_extra_keys!
            ],
            total:        all_communities.count,
            current_page:    1
        }

        pattern2 = {
            communities: [
                {
                    id:     all_communities[20].id
                }.ignore_extra_keys!,
                {
                    id:     all_communities[21].id
                }.ignore_extra_keys!,
                {
                    id:     all_communities[22].id
                }.ignore_extra_keys!,
                {
                    id:     all_communities[23].id
                }.ignore_extra_keys!,
                {
                    id:     all_communities[24].id
                }.ignore_extra_keys!
            ],
            total:        all_communities.count,
            current_page:    2
        }
        get '/api/v1/my_communities?page=1', headers: @headers
        expect(response.body).to match_json_expression(pattern1)

        get '/api/v1/my_communities?page=2', headers: @headers
        expect(response.body).to match_json_expression(pattern2)
      end

      it 'return empty array' do
        get '/api/v1/my_communities?page=1', headers: @headers
        pattern ={
            communities: [],
            total:       0,
            current_page:   1
        }
        expect(response.body).to match_json_expression(pattern)
      end
    end

    context 'abnormal' do
      describe 'miss page ' do
        it 'return 400' do
          get '/api/v1/my_communities', headers: @headers
          expect(response.status).to eq(400)
        end
      end

      describe 'wrong type of page' do
        it 'return 400' do
          get '/api/v1/my_communities?page="a"', headers: @headers
          expect(response.status).to eq(400)
        end
      end
    end
  end

  describe 'get /hosting_communities' do
    before do
      @current_user = create(:user, :with_api_key)
      @headers = {'Access-Token' => @current_user.api_keys.last.access_token}
      @community = create(:community)
    end
    context 'normal' do
      it 'return 200' do
        @community.hosts << @current_user
        get '/api/v1/hosting_communities?page=1', headers: @headers
        expect(response.status).to eq(200)
      end

      it 'matches data-type pattern' do
        pattern = {
            communities: [
                {
                    id:             Integer,
                    name:           String,
                    thumbnail_url:  String,
                    next_cypher:    Array
                }
            ].ignore_extra_values!,

            total:           Integer,
            current_page:    Integer
        }
        @community.hosts << @current_user
        get '/api/v1/hosting_communities?page=1', headers: @headers
        expect(response.body).to match_json_expression(pattern)
      end

      it 'matches data-content pattern' do
      @community.hosts << @current_user
      get '/api/v1/hosting_communities?page=1', headers: @headers
        pattern = {
            communities: [
                {
                    id:             @community.id,
                    name:           @community.name,
                    thumbnail_url:  @community.thumbnail.url,
                    next_cypher:    Array
                }

            ].ignore_extra_values!,
            total:        @current_user.hosting_communities.count,
            current_page:    1
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
            order("community_hosts.created_at DESC")
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
            total:        all_communities.count,
            current_page:    1
        }
        get '/api/v1/hosting_communities?page=1', headers: @headers
        expect(response.body).to match_json_expression(pattern)
      end

      it 'paginate correctly' do
        25.times do
          community = create(:community)
          community.hosts << @current_user
        end
        all_communities = @current_user.hosting_communities.
            joins(:community_hosts).
            includes(:community_hosts).
            order("community_hosts.created_at DESC")
        pattern1 = {
            communities: [
                {
                    id:     all_communities[0].id
                }.ignore_extra_keys!,
                {
                    id:     all_communities[1].id
                }.ignore_extra_keys!,
                {
                    id:     all_communities[2].id
                }.ignore_extra_keys!,
                {
                    id:     all_communities[3].id
                }.ignore_extra_keys!,
                {
                    id:     all_communities[4].id
                }.ignore_extra_keys!,
                {
                    id:     all_communities[5].id
                }.ignore_extra_keys!,
                {
                    id:     all_communities[6].id
                }.ignore_extra_keys!,
                {
                    id:     all_communities[7].id
                }.ignore_extra_keys!,
                {
                    id:     all_communities[8].id
                }.ignore_extra_keys!,
                {
                    id:     all_communities[9].id
                }.ignore_extra_keys!,
                {
                    id:     all_communities[10].id
                }.ignore_extra_keys!,
                {
                    id:     all_communities[11].id
                }.ignore_extra_keys!,
                {
                    id:     all_communities[12].id
                }.ignore_extra_keys!,
                {
                    id:     all_communities[13].id
                }.ignore_extra_keys!,
                {
                    id:     all_communities[14].id
                }.ignore_extra_keys!,
                {
                    id:     all_communities[15].id
                }.ignore_extra_keys!,
                {
                    id:     all_communities[16].id
                }.ignore_extra_keys!,
                {
                    id:     all_communities[17].id
                }.ignore_extra_keys!,
                {
                    id:     all_communities[18].id
                }.ignore_extra_keys!,
                {
                    id:     all_communities[19].id
                }.ignore_extra_keys!
            ],
            total:        all_communities.count,
            current_page:    1
        }

        pattern2 = {
            communities: [
                {
                    id:     all_communities[20].id
                }.ignore_extra_keys!,
                {
                    id:     all_communities[21].id
                }.ignore_extra_keys!,
                {
                    id:     all_communities[22].id
                }.ignore_extra_keys!,
                {
                    id:     all_communities[23].id
                }.ignore_extra_keys!,
                {
                    id:     all_communities[24].id
                }.ignore_extra_keys!
            ],
            total:        all_communities.count,
            current_page:    2
        }
        get '/api/v1/hosting_communities?page=1', headers: @headers
        expect(response.body).to match_json_expression(pattern1)

        get '/api/v1/hosting_communities?page=2', headers: @headers
        expect(response.body).to match_json_expression(pattern2)
      end
    end

    context 'abnormal' do
      describe 'miss page ' do
        it 'return 400' do
          get '/api/v1/hosting_communities', headers: @headers
          expect(response.status).to eq(400)
        end
      end

      describe 'wrong type of page' do
        it 'return 400' do
          get '/api/v1/hosting_communities?page="a"', headers: @headers
          expect(response.status).to eq(400)
        end
      end
    end
  end

  describe 'get /following_communities' do
    before do
      @current_user = create(:user, :with_api_key)
      @headers = {'Access-Token' => @current_user.api_keys.last.access_token}
      @community = create(:community)
    end
    context 'normal' do
      it 'return 200' do
        @community.followers << @current_user
        get '/api/v1/following_communities?page=1', headers: @headers
        expect(response.status).to eq(200)
      end

      it 'matches data-type pattern' do
        pattern = {
            communities: [
                {
                    id:             Integer,
                    name:           String,
                    thumbnail_url:  String,
                    next_cypher:    Array
                }
            ].ignore_extra_values!,

            total:           Integer,
            current_page:    Integer
        }
        @community.followers << @current_user
        get '/api/v1/following_communities?page=1', headers: @headers
        expect(response.body).to match_json_expression(pattern)
      end

      it 'matches data-content pattern' do
        @community.followers << @current_user
        get '/api/v1/following_communities?page=1', headers: @headers
        pattern = {
            communities: [
                {
                    id:             @community.id,
                    name:           @community.name,
                    thumbnail_url:  @community.thumbnail.url,
                    next_cypher:    Array
                }

            ].ignore_extra_values!,
            total:        @current_user.following_communities.count,
            current_page:    1
        }
        expect(response.body).to match_json_expression(pattern)
      end

      it 'order correctly' do
        3.times do
          community = create(:community)
          community.followers << @current_user
        end
        all_communities = @current_user.following_communities.
            joins(:community_followers).
            includes(:community_followers).
            order("community_followers.created_at DESC")
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
            total:        all_communities.count,
            current_page:    1
        }
        get '/api/v1/following_communities?page=1', headers: @headers
        expect(response.body).to match_json_expression(pattern)
      end

      it 'paginate correctly' do
        25.times do
          community = create(:community)
          community.followers << @current_user
        end
        all_communities = @current_user.following_communities.
            joins(:community_followers).
            includes(:community_followers).
            order("community_followers.created_at DESC")
        pattern1 = {
            communities: [
                {
                    id:     all_communities[0].id
                }.ignore_extra_keys!,
                {
                    id:     all_communities[1].id
                }.ignore_extra_keys!,
                {
                    id:     all_communities[2].id
                }.ignore_extra_keys!,
                {
                    id:     all_communities[3].id
                }.ignore_extra_keys!,
                {
                    id:     all_communities[4].id
                }.ignore_extra_keys!,
                {
                    id:     all_communities[5].id
                }.ignore_extra_keys!,
                {
                    id:     all_communities[6].id
                }.ignore_extra_keys!,
                {
                    id:     all_communities[7].id
                }.ignore_extra_keys!,
                {
                    id:     all_communities[8].id
                }.ignore_extra_keys!,
                {
                    id:     all_communities[9].id
                }.ignore_extra_keys!,
                {
                    id:     all_communities[10].id
                }.ignore_extra_keys!,
                {
                    id:     all_communities[11].id
                }.ignore_extra_keys!,
                {
                    id:     all_communities[12].id
                }.ignore_extra_keys!,
                {
                    id:     all_communities[13].id
                }.ignore_extra_keys!,
                {
                    id:     all_communities[14].id
                }.ignore_extra_keys!,
                {
                    id:     all_communities[15].id
                }.ignore_extra_keys!,
                {
                    id:     all_communities[16].id
                }.ignore_extra_keys!,
                {
                    id:     all_communities[17].id
                }.ignore_extra_keys!,
                {
                    id:     all_communities[18].id
                }.ignore_extra_keys!,
                {
                    id:     all_communities[19].id
                }.ignore_extra_keys!
            ],
            total:        all_communities.count,
            current_page:    1
        }

        pattern2 = {
            communities: [
                {
                    id:     all_communities[20].id
                }.ignore_extra_keys!,
                {
                    id:     all_communities[21].id
                }.ignore_extra_keys!,
                {
                    id:     all_communities[22].id
                }.ignore_extra_keys!,
                {
                    id:     all_communities[23].id
                }.ignore_extra_keys!,
                {
                    id:     all_communities[24].id
                }.ignore_extra_keys!
            ],
            total:        all_communities.count,
            current_page:    2
        }
        get '/api/v1/following_communities?page=1', headers: @headers
        expect(response.body).to match_json_expression(pattern1)

        get '/api/v1/following_communities?page=2', headers: @headers
        expect(response.body).to match_json_expression(pattern2)
      end

      it 'return empty array' do
        get '/api/v1/following_communities?page=1', headers: @headers
        pattern ={
            communities: [],
            total:       0,
            current_page:   1
        }
        expect(response.body).to match_json_expression(pattern)
      end
    end

    context 'abnormal' do
      describe 'miss page ' do
        it 'return 400' do
          get '/api/v1/following_communities', headers: @headers
          expect(response.status).to eq(400)
        end
      end

      describe 'wrong type of page' do
        it 'return 400' do
          get '/api/v1/following_communities?page="a"', headers: @headers
          expect(response.status).to eq(400)
        end
      end
    end
  end
end