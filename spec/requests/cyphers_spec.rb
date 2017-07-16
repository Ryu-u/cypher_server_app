require 'rails_helper'

RSpec.describe "Cyphers", type: :request do
  before do
    @cypher = create(:cypher, :with_tag,
                        community: create(:community),
                        host: create(:host)
                     )
    @current_user = create(:user, :with_api_key)
    @headers = {'Access-Token' => @current_user.api_keys.last.access_token}
  end

  describe 'get /cyphers/id' do
    context 'normal' do
      it 'return 200 OK' do
        get "/api/v1/cyphers/#{@cypher.id}", headers: @headers
        expect(response.status).to eq(200)
      end


      it 'matches data-type pattern' do
        pattern = {
            cypher: {
                id:                 Integer,
                name:               String,
                serial_num:         Integer,
                thumbnail_url:      String,
                cypher_from:        String,
                cypher_to:          String,
                place:              String,
                info:               String,
                capacity:           Integer,
                host:               Hash,
                community:          Hash,
                tags:               [
                                      {
                                          id:       Integer,
                                          content:  String
                                      }
                ].ignore_extra_values!,
                }
        }
        get "/api/v1/cyphers/#{@cypher.id}", headers: @headers
        expect(response.body).to match_json_expression(pattern)
      end

      it 'matches data-content pattern' do
        pattern = {
            cypher: {
                id:                 @cypher.id,
                name:               @cypher.name,
                serial_num:         @cypher.serial_num,
                thumbnail_url:      @cypher.community.thumbnail.url,
                cypher_from:        @cypher.cypher_from.to_s(:default),
                cypher_to:          @cypher.cypher_to.to_s(:default),
                place:              @cypher.place,
                info:               @cypher.info,
                capacity:           @cypher.capacity,
                host:               {
                                        id: @cypher.host.id
                }.ignore_extra_keys!,
                community:          {
                                        id: @cypher.community.id
                }.ignore_extra_keys!,
                tags:               [
                                      {
                                          id:       @cypher.tags[0].id,
                                          content:  @cypher.tags[0].content,
                                      },
                                      {
                                          id:       @cypher.tags[1].id,
                                          content:  @cypher.tags[1].content,
                                      },
                                      {
                                          id:       @cypher.tags[2].id,
                                          content:  @cypher.tags[2].content,
                                      }
                ].unordered!,
            }
        }
        get "/api/v1/cyphers/#{@cypher.id}", headers: @headers
        expect(response.body).to match_json_expression(pattern)
      end
    end
    context 'abnormal' do
      before do
        @cypher = FactoryGirl::create(:cypher,
                                      community: FactoryGirl::create(:community),
                                      host: FactoryGirl::create(:host))
        @current_user = create(:user, :with_api_key)
        @headers = {'Access-Token' => @current_user.api_keys.last.access_token}
      end

      it 'return 400' do
        get '/api/v1/cyphers/a', headers: @headers
        expect(response.status).to eq(400)
      end

      it 'return 404' do
        get "/api/v1/cyphers/9999", headers: @headers
        expect(response.status).to eq(404)
      end
    end
  end

  describe 'get /participating_cyphers' do
    before do
      unless RSpec.current_example.metadata[:skipbefore]
        @current_user = create(:user, :with_api_key)
        @headers = {'Access-Token' => @current_user.api_keys.last.access_token}
        @cypher = create(:cypher,
                         cypher_from: DateTime.now + 10,
                         cypher_to:   (DateTime.now + 10 ) + Rational(2,24),
                         community: create(:community),
                         host: create(:host))
        @current_user.participating_cyphers << @cypher
      end
    end
    context 'normal' do
      it 'return 200' do
        get '/api/v1/participating_cyphers?since_id=0&cypher_from=', headers: @headers
        expect(response.status).to eq(200)
      end

      it 'matches data-type pattern' do
        pattern = {
            cyphers: [
                {
                    id:             Integer,
                    name:           String,
                    serial_num:     Integer,
                    cypher_from:    String,
                    cypher_to:      String,
                    place:          String,
                    capacity:       Integer,
                    thumbnail_url:  String
                }
            ],
            total:                  Integer
        }
        get '/api/v1/participating_cyphers?since_id=0&cypher_from=', headers: @headers
        expect(response.body).to match_json_expression(pattern)
      end

      it 'matches data-content pattern' do
        pattern = {
            cyphers: [
                {
                    id:             @cypher.id,
                    name:           @cypher.name,
                    serial_num:     @cypher.serial_num,
                    cypher_from:    @cypher.cypher_from.to_s(:default),
                    cypher_to:      @cypher.cypher_to.to_s(:default),
                    place:          @cypher.place,
                    capacity:       @cypher.capacity,
                    thumbnail_url:  @cypher.community.thumbnail.url
                }
            ],
            total:                  1
        }
        get '/api/v1/participating_cyphers?since_id=0&cypher_from=', headers: @headers
        expect(response.body).to match_json_expression(pattern)
      end

      it 'paginates correctly', skip_before: true do
        here_user = create(:user, :with_api_key)
        @headers = {'Access-Token' => here_user.api_keys.last.access_token}
        for i in 101..119 do
          if i == 118
            next
          end
          c = create(:cypher,
                     id: i,
                     cypher_from: DateTime.now.to_date + i,
                     cypher_to:   (DateTime.now.to_date + i ) + Rational(2,24),
                     community: create(:community),
                     host: create(:host))
          here_user.participating_cyphers << c
        end
        c_118 = create(:cypher,
                       id: 118,
                       cypher_from: DateTime.now.to_date + 122,
                       cypher_to:   (DateTime.now.to_date + 122 ) + Rational(2,24),
                       community: create(:community),
                       host: create(:host))
        here_user.participating_cyphers << c_118
        for i in 120..122 do
          c = create(:cypher,
                     id: i,
                     cypher_from: DateTime.now.to_date + 120,
                     cypher_to:   (DateTime.now.to_date + 120 ) + Rational(2,24),
                     community: create(:community),
                     host: create(:host))
          here_user.participating_cyphers << c
        end

        for i in 123..125 do
          c = create(:cypher,
                     id: i,
                     cypher_from: DateTime.now.to_date + i,
                     cypher_to:   (DateTime.now.to_date + i ) + Rational(2,24),
                     community: create(:community),
                     host: create(:host))
          here_user.participating_cyphers << c
        end

        all_cyphers = here_user.
                        participating_cyphers.
                        ordering{|cypher| [cypher.cypher_from.asc, cypher.id.asc]}


        pattern1 = {
            cyphers: [
                {id: all_cyphers[0].id}.ignore_extra_keys!,
                {id: all_cyphers[1].id}.ignore_extra_keys!,
                {id: all_cyphers[2].id}.ignore_extra_keys!,
                {id: all_cyphers[3].id}.ignore_extra_keys!,
                {id: all_cyphers[4].id}.ignore_extra_keys!,
                {id: all_cyphers[5].id}.ignore_extra_keys!,
                {id: all_cyphers[6].id}.ignore_extra_keys!,
                {id: all_cyphers[7].id}.ignore_extra_keys!,
                {id: all_cyphers[8].id}.ignore_extra_keys!,
                {id: all_cyphers[9].id}.ignore_extra_keys!,
                {id: all_cyphers[10].id}.ignore_extra_keys!,
                {id: all_cyphers[11].id}.ignore_extra_keys!,
                {id: all_cyphers[12].id}.ignore_extra_keys!,
                {id: all_cyphers[13].id}.ignore_extra_keys!,
                {id: all_cyphers[14].id}.ignore_extra_keys!,
                {id: all_cyphers[15].id}.ignore_extra_keys!,
                {id: all_cyphers[16].id}.ignore_extra_keys!,
                {id: all_cyphers[17].id}.ignore_extra_keys!,
                {id: all_cyphers[18].id}.ignore_extra_keys!,
                {id: all_cyphers[19].id}.ignore_extra_keys!
            ],
            total:        25
        }

        pattern2 ={
            cyphers: [
                { id: all_cyphers[20].id}.ignore_extra_keys!,
                { id: all_cyphers[21].id}.ignore_extra_keys!,
                { id: all_cyphers[22].id}.ignore_extra_keys!,
                { id: all_cyphers[23].id}.ignore_extra_keys!,
                { id: all_cyphers[24].id}.ignore_extra_keys!

            ]
        }.ignore_extra_keys!
        get '/api/v1/participating_cyphers?since_id=0&cypher_from=', headers: @headers
        expect(response.body).to match_json_expression(pattern1)

        get "/api/v1/participating_cyphers?since_id=#{all_cyphers[19].id}&cypher_from=#{all_cyphers[19].cypher_from.to_s(:default)}", headers: @headers
        expect(response.body).to match_json_expression(pattern2)
      end

      it 'return empty array' do
        user = create(:user, :with_api_key)
        pattern = {
            cyphers: [],
            total:   0
        }
        get '/api/v1/participating_cyphers?since_id=0&cypher_from=', headers: {'Access-Token' => user.api_keys.last.access_token}
        expect(response.body).to match_json_expression(pattern)
      end
    end

    context 'abnormal' do
      describe 'miss since_id' do
        it 'return 400' do
          get '/api/v1/participating_cyphers?cypher_from=', headers: @headers
          expect(response.status).to eq(400)
        end
      end

      describe 'miss cypher_from' do
        it 'return 400' do
          get '/api/v1/participating_cyphers?since_id=0', headers: @headers
          expect(response.status).to eq(400)
        end
      end

      describe 'wrong type of since_id' do
        it 'return 400' do
          get '/api/v1/participating_cyphers?since_id="a"&cypher_from=', headers: @headers
          expect(response.status).to eq(400)
        end
      end

      describe 'wrong type of cypher_from' do
        it 'return 400' do
          get '/api/v1/participating_cyphers?since_id=0&cypher_from=99', headers: @headers
          expect(response.status).to eq(400)
        end
      end

    end
  end

  describe 'get /hosting_cyphers' do
    before do
      unless RSpec.current_example.metadata[:skipbefore]
        @current_user = create(:user, :with_api_key)
        @headers = {'Access-Token' => @current_user.api_keys.last.access_token}
        @cypher = create(:cypher,
                         cypher_from: DateTime.now + 10,
                         cypher_to:   (DateTime.now + 10 ) + Rational(2,24),
                         community: create(:community),
                         host: create(:host))
        @current_user.hosting_cyphers << @cypher
      end
    end
    context 'normal' do
      it 'return 200' do
        get '/api/v1/hosting_cyphers?since_id=0&cypher_from=', headers: @headers
        expect(response.status).to eq(200)
      end

      it 'matches data-type pattern' do
        pattern = {
            cyphers: [
                {
                    id:             Integer,
                    name:           String,
                    serial_num:     Integer,
                    cypher_from:    String,
                    cypher_to:      String,
                    place:          String,
                    capacity:       Integer,
                    thumbnail_url:  String
                }
            ],
            total:                  Integer
        }
        get '/api/v1/hosting_cyphers?since_id=0&cypher_from=', headers: @headers
        expect(response.body).to match_json_expression(pattern)
      end

      it 'matches data-content pattern' do
        pattern = {
            cyphers: [
                {
                    id:             @cypher.id,
                    name:           @cypher.name,
                    serial_num:     @cypher.serial_num,
                    cypher_from:    @cypher.cypher_from.to_s(:default),
                    cypher_to:      @cypher.cypher_to.to_s(:default),
                    place:          @cypher.place,
                    capacity:       @cypher.capacity,
                    thumbnail_url:  @cypher.community.thumbnail.url
                }
            ],
            total:                  1
        }
        get '/api/v1/hosting_cyphers?since_id=0&cypher_from=', headers: @headers
        expect(response.body).to match_json_expression(pattern)
      end

      it 'paginates correctly', skip_before: true do
        DatabaseCleaner.clean
        here_user = create(:user, :with_api_key)
        @headers = {'Access-Token' => here_user.api_keys.last.access_token}
        for i in 101..119 do
          if i == 118
            next
          end
          c = create(:cypher,
                     id: i,
                     cypher_from: DateTime.now.to_date + i,
                     cypher_to:   (DateTime.now.to_date + i ) + Rational(2,24),
                     community: create(:community),
                     host: create(:host))
          here_user.hosting_cyphers << c
        end
        c_118 = create(:cypher,
                       id: 118,
                       cypher_from: DateTime.now.to_date + 122,
                       cypher_to:   (DateTime.now.to_date + 122 ) + Rational(2,24),
                       community: create(:community),
                       host: create(:host))
        here_user.hosting_cyphers << c_118
        for i in 120..122 do
          c = create(:cypher,
                     id: i,
                     cypher_from: DateTime.now.to_date + 120,
                     cypher_to:   (DateTime.now.to_date + 120 ) + Rational(2,24),
                     community: create(:community),
                     host: create(:host))
          here_user.hosting_cyphers << c
        end

        for i in 123..125 do
          c = create(:cypher,
                     id: i,
                     cypher_from: DateTime.now.to_date + i,
                     cypher_to:   (DateTime.now.to_date + i ) + Rational(2,24),
                     community: create(:community),
                     host: create(:host))
          here_user.hosting_cyphers << c
        end

        all_cyphers = here_user.
                          hosting_cyphers.
                          ordering{|cypher| [cypher.cypher_from.asc, cypher.id.asc]}


        pattern1 = {
            cyphers: [
                {id: all_cyphers[0].id}.ignore_extra_keys!,
                {id: all_cyphers[1].id}.ignore_extra_keys!,
                {id: all_cyphers[2].id}.ignore_extra_keys!,
                {id: all_cyphers[3].id}.ignore_extra_keys!,
                {id: all_cyphers[4].id}.ignore_extra_keys!,
                {id: all_cyphers[5].id}.ignore_extra_keys!,
                {id: all_cyphers[6].id}.ignore_extra_keys!,
                {id: all_cyphers[7].id}.ignore_extra_keys!,
                {id: all_cyphers[8].id}.ignore_extra_keys!,
                {id: all_cyphers[9].id}.ignore_extra_keys!,
                {id: all_cyphers[10].id}.ignore_extra_keys!,
                {id: all_cyphers[11].id}.ignore_extra_keys!,
                {id: all_cyphers[12].id}.ignore_extra_keys!,
                {id: all_cyphers[13].id}.ignore_extra_keys!,
                {id: all_cyphers[14].id}.ignore_extra_keys!,
                {id: all_cyphers[15].id}.ignore_extra_keys!,
                {id: all_cyphers[16].id}.ignore_extra_keys!,
                {id: all_cyphers[17].id}.ignore_extra_keys!,
                {id: all_cyphers[18].id}.ignore_extra_keys!,
                {id: all_cyphers[19].id}.ignore_extra_keys!
            ],
            total:        25
        }

        pattern2 ={
            cyphers: [
                { id: all_cyphers[20].id}.ignore_extra_keys!,
                { id: all_cyphers[21].id}.ignore_extra_keys!,
                { id: all_cyphers[22].id}.ignore_extra_keys!,
                { id: all_cyphers[23].id}.ignore_extra_keys!,
                { id: all_cyphers[24].id}.ignore_extra_keys!

            ]
        }.ignore_extra_keys!
        get '/api/v1/hosting_cyphers?since_id=0&cypher_from=', headers: @headers
        expect(response.body).to match_json_expression(pattern1)

        get "/api/v1/hosting_cyphers?since_id=#{all_cyphers[19].id}&cypher_from=#{all_cyphers[19].cypher_from.to_s(:default)}", headers: @headers
        expect(response.body).to match_json_expression(pattern2)
      end

      it 'return empty array' do
        user = create(:user, :with_api_key)
        pattern = {
            cyphers: [],
            total:   0
        }
        get '/api/v1/hosting_cyphers?since_id=0&cypher_from=', headers: {'Access-Token' => user.api_keys.last.access_token}
        expect(response.body).to match_json_expression(pattern)
      end
    end

    context 'abnormal' do
      describe 'miss since_id' do
        it 'return 400' do
          get '/api/v1/hosting_cyphers?cypher_from=', headers: @headers
          expect(response.status).to eq(400)
        end
      end

      describe 'miss cypher_from' do
        it 'return 400' do
          get '/api/v1/hosting_cyphers?since_id=0', headers: @headers
          expect(response.status).to eq(400)
        end
      end

      describe 'wrong type of since_id' do
        it 'return 400' do
          get '/api/v1/hosting_cyphers?since_id="a"&cypher_from=', headers: @headers
          expect(response.status).to eq(400)
        end
      end

      describe 'wrong type of cypher_from' do
        it 'return 400' do
          get '/api/v1/hosting_cyphers?since_id="a"&cypher_from=99', headers: @headers
          expect(response.status).to eq(400)
        end
      end

    end
  end

  describe 'get /cyphers' do
    before do
      DatabaseCleaner.clean
      unless RSpec.current_example.metadata[:skipbefore]
        @current_user = create(:user, :with_api_key)
        @headers = {'Access-Token' => @current_user.api_keys.last.access_token}
        @cypher = create(:cypher,
                         cypher_from: DateTime.now + 10,
                         cypher_to:   (DateTime.now + 10 ) + Rational(2,24),
                         community: create(:community),
                         host: create(:user)
                        )
      end
    end
    context 'normal' do
      it 'return 200' do
        get "/api/v1/cyphers?since_id=0&cypher_from=", headers: @headers
        expect(response.status).to eq(200)
      end

      it 'matches data-content pattern' do
        pattern = {
            cyphers: [
                {
                    id:             @cypher.id,
                    name:           @cypher.name,
                    serial_num:     @cypher.serial_num,
                    cypher_from:    @cypher.cypher_from.to_s(:default),
                    cypher_to:      @cypher.cypher_to.to_s(:default),
                    place:          @cypher.place,
                    capacity:       @cypher.capacity,
                    thumbnail_url:  @cypher.community.thumbnail.url
                }
            ],
            total:                  1
        }
        get "/api/v1/cyphers?since_id=0&cypher_from=", headers: @headers, headers: @headers
        expect(response.body).to match_json_expression(pattern)
      end

      it 'paginates correctly', skipbefore: true do
        DatabaseCleaner.clean
        here_user = create(:user, :with_api_key)
        @headers = {'Access-Token' => here_user.api_keys.last.access_token}
        for i in 101..119 do
          if i == 118
            next
          end
          c = create(:cypher,
                     id: i,
                     cypher_from: DateTime.now.to_date + i,
                     cypher_to:   (DateTime.now.to_date + i ) + Rational(2,24),
                     community: create(:community),
                     host: create(:host)
                    )
        end
        c_118 = create(:cypher,
                       id: 118,
                       cypher_from: DateTime.now.to_date + 122,
                       cypher_to:   (DateTime.now.to_date + 122 ) + Rational(2,24),
                       community: create(:community),
                       host: create(:host)
                      )
        for i in 120..122 do
          c = create(:cypher,
                     id: i,
                     cypher_from: DateTime.now.to_date + 120,
                     cypher_to:   (DateTime.now.to_date + 120 ) + Rational(2,24),
                     community: create(:community),
                     host: create(:host)
                    )
        end

        for i in 123..125 do
          c = create(:cypher,
                     id: i,
                     cypher_from: DateTime.now.to_date + i,
                     cypher_to:   (DateTime.now.to_date + i ) + Rational(2,24),
                     community: create(:community),
                     host: create(:host))
        end

        all_cyphers = Cypher.
                        ordering{|cypher| [cypher.cypher_from.asc, cypher.id.asc]}


        pattern1 = {
            cyphers: [
                {id: all_cyphers[0].id}.ignore_extra_keys!,
                {id: all_cyphers[1].id}.ignore_extra_keys!,
                {id: all_cyphers[2].id}.ignore_extra_keys!,
                {id: all_cyphers[3].id}.ignore_extra_keys!,
                {id: all_cyphers[4].id}.ignore_extra_keys!,
                {id: all_cyphers[5].id}.ignore_extra_keys!,
                {id: all_cyphers[6].id}.ignore_extra_keys!,
                {id: all_cyphers[7].id}.ignore_extra_keys!,
                {id: all_cyphers[8].id}.ignore_extra_keys!,
                {id: all_cyphers[9].id}.ignore_extra_keys!,
                {id: all_cyphers[10].id}.ignore_extra_keys!,
                {id: all_cyphers[11].id}.ignore_extra_keys!,
                {id: all_cyphers[12].id}.ignore_extra_keys!,
                {id: all_cyphers[13].id}.ignore_extra_keys!,
                {id: all_cyphers[14].id}.ignore_extra_keys!,
                {id: all_cyphers[15].id}.ignore_extra_keys!,
                {id: all_cyphers[16].id}.ignore_extra_keys!,
                {id: all_cyphers[17].id}.ignore_extra_keys!,
                {id: all_cyphers[18].id}.ignore_extra_keys!,
                {id: all_cyphers[19].id}.ignore_extra_keys!
            ],
            total:        25
        }

        pattern2 ={
            cyphers: [
                { id: all_cyphers[20].id}.ignore_extra_keys!,
                { id: all_cyphers[21].id}.ignore_extra_keys!,
                { id: all_cyphers[22].id}.ignore_extra_keys!,
                { id: all_cyphers[23].id}.ignore_extra_keys!,
                { id: all_cyphers[24].id}.ignore_extra_keys!

            ],
        }.ignore_extra_keys!
        get '/api/v1/cyphers?since_id=0&cypher_from=', headers: @headers
        expect(response.body).to match_json_expression(pattern1)

        get "/api/v1/cyphers?since_id=#{all_cyphers[19].id}&cypher_from=#{all_cyphers[19].cypher_from.to_s(:default)}", headers: @headers
        expect(response.body).to match_json_expression(pattern2)
      end

      it 'return empty array', skipbefore: true do
        user = create(:user, :with_api_key)
        pattern = {
            cyphers: [],
            total:   0
        }
        get '/api/v1/cyphers?since_id=9999&cypher_from=', headers: {'Access-Token' => user.api_keys.last.access_token}
        expect(response.body).to match_json_expression(pattern)
      end
    end

    context 'abnormal' do
      describe 'miss since_id' do
        it 'return 400' do
          get '/api/v1/cyphers?cypher_from=', headers: @headers
          expect(response.status).to eq(400)
        end
      end

      describe 'miss cypher_from' do
        it 'return 400' do
          get '/api/v1/cyphers?since_id=0', headers: @headers
          expect(response.status).to eq(400)
        end
      end

      describe 'wrong type of since_id' do
        it 'return 400' do
          get '/api/v1/cyphers?since_id="a"&cypher_from=', headers: @headers
          expect(response.status).to eq(400)
        end
      end

      describe 'wrong type of cypher_from' do
        it 'return 400' do
          get '/api/v1/cyphers?since_id="a"&cypher_from=99', headers: @headers
          expect(response.status).to eq(400)
        end
      end

    end
  end
end
