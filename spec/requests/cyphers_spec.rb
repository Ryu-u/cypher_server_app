require 'rails_helper'

RSpec.describe "Cyphers", type: :request do
  before do
    @cypher = FactoryGirl::create(:cypher,
                        community: FactoryGirl::create(:community),
                        host: FactoryGirl::create(:host))
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
                community:          Hash
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
                cypher_from:        @cypher.cypher_from,
                cypher_to:          @cypher.cypher_to,
                place:              @cypher.place,
                info:               @cypher.info,
                capacity:           @cypher.capacity,
                host:               {
                                        id: @cypher.host.id
                }.ignore_extra_keys!,
                community:          {
                                        id: @cypher.community.id
                }.ignore_extra_keys!
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
      @current_user = create(:user, :with_api_key)
      @headers = {'Access-Token' => @current_user.api_keys.last.access_token}
      @cypher = create(:cypher,
                       cypher_from: DateTime.now + 10,
                       cypher_to:   (DateTime.now + 10 ) + Rational(2,24),
                       community: create(:community),
                       host: create(:host))
      @current_user.participating_cyphers << @cypher
    end
    context 'normal' do
      it 'return 200' do
        get '/api/v1/participating_cyphers?page=1', headers: @headers
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
            total:                  Integer,
            current_page:           Integer
        }
        get '/api/v1/participating_cyphers?page=1', headers: @headers
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
            total:                  1,
            current_page:           1
        }
        get '/api/v1/participating_cyphers?page=1', headers: @headers
        expect(response.body).to match_json_expression(pattern)
      end

      it 'paginates correctly' do
        29.times do
          c = create(:cypher,
                     cypher_from: DateTime.now + 10,
                     cypher_to:   (DateTime.now + 10 ) + Rational(2,24),
                     community: create(:community),
                      host: create(:host))
          @current_user.participating_cyphers << c
        end
        all_cyphers = @current_user.
                        participating_cyphers.
                        order("cyphers.cypher_from DESC")


        pattern1 = {
            cyphers: [
                {
                    id:       all_cyphers[0].id
                }.ignore_extra_keys!,
                {
                    id:       all_cyphers[1].id
                }.ignore_extra_keys!,
                {
                    id:       all_cyphers[2].id
                }.ignore_extra_keys!,
                {
                    id:       all_cyphers[3].id
                }.ignore_extra_keys!,
                {
                    id:       all_cyphers[4].id
                }.ignore_extra_keys!,
                {
                    id:       all_cyphers[5].id
                }.ignore_extra_keys!,
                {
                    id:       all_cyphers[6].id
                }.ignore_extra_keys!,
                {
                    id:       all_cyphers[7].id
                }.ignore_extra_keys!,
                {
                    id:       all_cyphers[8].id
                }.ignore_extra_keys!,
                {
                    id:       all_cyphers[9].id
                }.ignore_extra_keys!,
                {
                    id:       all_cyphers[10].id
                }.ignore_extra_keys!,
                {
                    id:       all_cyphers[11].id
                }.ignore_extra_keys!,
                {
                    id:       all_cyphers[12].id
                }.ignore_extra_keys!,
                {
                    id:       all_cyphers[13].id
                }.ignore_extra_keys!,
                {
                    id:       all_cyphers[14].id
                }.ignore_extra_keys!,
                {
                    id:       all_cyphers[15].id
                }.ignore_extra_keys!,
                {
                    id:       all_cyphers[16].id
                }.ignore_extra_keys!,
                {
                    id:       all_cyphers[17].id
                }.ignore_extra_keys!,
                {
                    id:       all_cyphers[18].id
                }.ignore_extra_keys!,
                {
                    id:       all_cyphers[19].id
                }.ignore_extra_keys!
            ],
            total:        30,
            current_page: 1
        }

        pattern2 ={
            cyphers: [
                {
                    id:       all_cyphers[20].id
                }.ignore_extra_keys!,
                {
                    id:       all_cyphers[21].id
                }.ignore_extra_keys!,
                {
                    id:       all_cyphers[22].id
                }.ignore_extra_keys!,
                {
                    id:       all_cyphers[23].id
                }.ignore_extra_keys!,
                {
                    id:       all_cyphers[24].id
                }.ignore_extra_keys!,
                {
                    id:       all_cyphers[25].id
                }.ignore_extra_keys!,
                {
                    id:       all_cyphers[26].id
                }.ignore_extra_keys!,
                {
                    id:       all_cyphers[27].id
                }.ignore_extra_keys!,
                {
                    id:       all_cyphers[28].id
                }.ignore_extra_keys!,
                {
                    id:       all_cyphers[29].id
                }.ignore_extra_keys!
            ],
            total:        30,
            current_page: 2
        }
        get '/api/v1/participating_cyphers?page=1', headers: @headers
        expect(response.body).to match_json_expression(pattern1)

        get '/api/v1/participating_cyphers?page=2', headers: @headers
        expect(response.body).to match_json_expression(pattern2)
      end

      it 'retrun empty array' do
        user = create(:user, :with_api_key)
        pattern = {
            cyphers: [],
            total:   0,
            current_page: 100
        }
        get '/api/v1/participating_cyphers?page=100', headers: {'Access-Token' => user.api_keys.last.access_token}
        expect(response.body).to match_json_expression(pattern)
      end
    end

    context 'abnormal' do
      describe 'miss page' do
        it 'return 400' do
          get '/api/v1/participating_cyphers', headers: @headers
          expect(response.status).to eq(400)
        end
      end

      describe 'wrong type of page' do
        it 'return 400' do
          get '/api/v1/participating_cyphers?page="a"', headers: @headers
          expect(response.status).to eq(400)
        end
      end

    end
  end

  describe 'get /hosting_cyphers' do
    before do
      @current_user = create(:user, :with_api_key)
      @headers = {'Access-Token' => @current_user.api_keys.last.access_token}
      @cypher = create(:cypher,
                       cypher_from: DateTime.now + 10,
                       cypher_to:   (DateTime.now + 10 ) + Rational(2,24),
                       community: create(:community),
                       host: @current_user)
    end
    context 'normal' do
      it 'return 200' do
        get '/api/v1/participating_cyphers?page=1', headers: @headers
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
            total:                  1,
            current_page:           1
        }
        get '/api/v1/hosting_cyphers?page=1', headers: @headers
        expect(response.body).to match_json_expression(pattern)
      end

      it 'paginates correctly' do
        29.times do
          c = create(:cypher,
                     cypher_from: DateTime.now + 10,
                     cypher_to:   (DateTime.now + 10 ) + Rational(2,24),
                     community: create(:community),
                     host: @current_user)
        end
        all_cyphers = @current_user.
            hosting_cyphers.
            order("cyphers.cypher_from DESC")


        pattern1 = {
            cyphers: [
                {
                    id:       all_cyphers[0].id
                }.ignore_extra_keys!,
                {
                    id:       all_cyphers[1].id
                }.ignore_extra_keys!,
                {
                    id:       all_cyphers[2].id
                }.ignore_extra_keys!,
                {
                    id:       all_cyphers[3].id
                }.ignore_extra_keys!,
                {
                    id:       all_cyphers[4].id
                }.ignore_extra_keys!,
                {
                    id:       all_cyphers[5].id
                }.ignore_extra_keys!,
                {
                    id:       all_cyphers[6].id
                }.ignore_extra_keys!,
                {
                    id:       all_cyphers[7].id
                }.ignore_extra_keys!,
                {
                    id:       all_cyphers[8].id
                }.ignore_extra_keys!,
                {
                    id:       all_cyphers[9].id
                }.ignore_extra_keys!,
                {
                    id:       all_cyphers[10].id
                }.ignore_extra_keys!,
                {
                    id:       all_cyphers[11].id
                }.ignore_extra_keys!,
                {
                    id:       all_cyphers[12].id
                }.ignore_extra_keys!,
                {
                    id:       all_cyphers[13].id
                }.ignore_extra_keys!,
                {
                    id:       all_cyphers[14].id
                }.ignore_extra_keys!,
                {
                    id:       all_cyphers[15].id
                }.ignore_extra_keys!,
                {
                    id:       all_cyphers[16].id
                }.ignore_extra_keys!,
                {
                    id:       all_cyphers[17].id
                }.ignore_extra_keys!,
                {
                    id:       all_cyphers[18].id
                }.ignore_extra_keys!,
                {
                    id:       all_cyphers[19].id
                }.ignore_extra_keys!
            ],
            total:        30,
            current_page: 1
        }

        pattern2 ={
            cyphers: [
                {
                    id:       all_cyphers[20].id
                }.ignore_extra_keys!,
                {
                    id:       all_cyphers[21].id
                }.ignore_extra_keys!,
                {
                    id:       all_cyphers[22].id
                }.ignore_extra_keys!,
                {
                    id:       all_cyphers[23].id
                }.ignore_extra_keys!,
                {
                    id:       all_cyphers[24].id
                }.ignore_extra_keys!,
                {
                    id:       all_cyphers[25].id
                }.ignore_extra_keys!,
                {
                    id:       all_cyphers[26].id
                }.ignore_extra_keys!,
                {
                    id:       all_cyphers[27].id
                }.ignore_extra_keys!,
                {
                    id:       all_cyphers[28].id
                }.ignore_extra_keys!,
                {
                    id:       all_cyphers[29].id
                }.ignore_extra_keys!
            ],
            total:        30,
            current_page: 2
        }
        get '/api/v1/hosting_cyphers?page=1', headers: @headers
        expect(response.body).to match_json_expression(pattern1)

        get '/api/v1/hosting_cyphers?page=2', headers: @headers
        expect(response.body).to match_json_expression(pattern2)
      end

      it 'retrun empty array' do
        user = create(:user, :with_api_key)
        pattern = {
            cyphers: [],
            total:   0,
            current_page: 100
        }
        get '/api/v1/hosting_cyphers?page=100', headers: {'Access-Token' => user.api_keys.last.access_token}
        expect(response.body).to match_json_expression(pattern)
      end
    end

    context 'abnormal' do
      describe 'miss page' do
        it 'return 400' do
          get '/api/v1/hosting_cyphers', headers: @headers
          expect(response.status).to eq(400)
        end
      end

      describe 'wrong type of page' do
        it 'return 400' do
          get '/api/v1/hosting_cyphers?page="a"', headers: @headers
          expect(response.status).to eq(400)
        end
      end

    end
  end

  describe 'get /home' do
    before do
      @current_user = create(:user, :with_api_key)
      @headers = {'Access-Token' => @current_user.api_keys.last.access_token}
      @cypher = create(:cypher,
                       cypher_from: DateTime.now + 10,
                       cypher_to:   (DateTime.now + 10 ) + Rational(2,24),
                       community: create(:community),
                       host: create(:user))
    end
    context 'normal' do
      it 'return 200' do
        get '/api/v1/participating_cyphers?page=1', headers: @headers
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
            total:                  1,
            current_page:           1
        }
        get '/api/v1/home?page=1', headers: @headers
        expect(response.body).to match_json_expression(pattern)
      end

      it 'paginates correctly' do
        29.times do
          c = create(:cypher,
                     cypher_from: DateTime.now + 10,
                     cypher_to:   (DateTime.now + 10 ) + Rational(2,24),
                     community: create(:community),
                     host: create(:user))
        end
        all_cyphers = Cypher.
            where(Cypher.arel_table[:cypher_from].gteq DateTime.now).
            order("cyphers.cypher_from DESC")

        pattern1 = {
            cyphers: [
                {
                    id:       all_cyphers[0].id
                }.ignore_extra_keys!,
                {
                    id:       all_cyphers[1].id
                }.ignore_extra_keys!,
                {
                    id:       all_cyphers[2].id
                }.ignore_extra_keys!,
                {
                    id:       all_cyphers[3].id
                }.ignore_extra_keys!,
                {
                    id:       all_cyphers[4].id
                }.ignore_extra_keys!,
                {
                    id:       all_cyphers[5].id
                }.ignore_extra_keys!,
                {
                    id:       all_cyphers[6].id
                }.ignore_extra_keys!,
                {
                    id:       all_cyphers[7].id
                }.ignore_extra_keys!,
                {
                    id:       all_cyphers[8].id
                }.ignore_extra_keys!,
                {
                    id:       all_cyphers[9].id
                }.ignore_extra_keys!,
                {
                    id:       all_cyphers[10].id
                }.ignore_extra_keys!,
                {
                    id:       all_cyphers[11].id
                }.ignore_extra_keys!,
                {
                    id:       all_cyphers[12].id
                }.ignore_extra_keys!,
                {
                    id:       all_cyphers[13].id
                }.ignore_extra_keys!,
                {
                    id:       all_cyphers[14].id
                }.ignore_extra_keys!,
                {
                    id:       all_cyphers[15].id
                }.ignore_extra_keys!,
                {
                    id:       all_cyphers[16].id
                }.ignore_extra_keys!,
                {
                    id:       all_cyphers[17].id
                }.ignore_extra_keys!,
                {
                    id:       all_cyphers[18].id
                }.ignore_extra_keys!,
                {
                    id:       all_cyphers[19].id
                }.ignore_extra_keys!
            ],
            total:        30,
            current_page: 1
        }

        pattern2 ={
            cyphers: [
                {
                    id:       all_cyphers[20].id
                }.ignore_extra_keys!,
                {
                    id:       all_cyphers[21].id
                }.ignore_extra_keys!,
                {
                    id:       all_cyphers[22].id
                }.ignore_extra_keys!,
                {
                    id:       all_cyphers[23].id
                }.ignore_extra_keys!,
                {
                    id:       all_cyphers[24].id
                }.ignore_extra_keys!,
                {
                    id:       all_cyphers[25].id
                }.ignore_extra_keys!,
                {
                    id:       all_cyphers[26].id
                }.ignore_extra_keys!,
                {
                    id:       all_cyphers[27].id
                }.ignore_extra_keys!,
                {
                    id:       all_cyphers[28].id
                }.ignore_extra_keys!,
                {
                    id:       all_cyphers[29].id
                }.ignore_extra_keys!
            ],
            total:        30,
            current_page: 2
        }
        get '/api/v1/home?page=1', headers: @headers
        expect(response.body).to match_json_expression(pattern1)

        get '/api/v1/home?page=2', headers: @headers
        expect(response.body).to match_json_expression(pattern2)
      end

      it 'retrun empty array' do
        user = create(:user, :with_api_key)
        @cypher.destroy
        pattern = {
            cyphers: [],
            total:   0,
            current_page: 100
        }
        get '/api/v1/home?page=100', headers: {'Access-Token' => user.api_keys.last.access_token}
        expect(response.body).to match_json_expression(pattern)
      end
    end

    context 'abnormal' do
      describe 'miss page' do
        it 'return 400' do
          get '/api/v1/home', headers: @headers
          expect(response.status).to eq(400)
        end
      end

      describe 'wrong type of page' do
        it 'return 400' do
          get '/api/v1/home?page="a"', headers: @headers
          expect(response.status).to eq(400)
        end
      end

    end
  end
end
