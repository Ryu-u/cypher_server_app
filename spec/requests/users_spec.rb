require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe 'get /login' do
    before do
      @login_user = create(:user, :with_api_key)
      @api_key = {firebase_uid: @login_user.api_keys.last.firebase_uid}
    end
    context 'normal' do
      it 'return 201 ' do
        post "/api/v1/users/login",@api_key.to_json , 'CONTENT_TYPE' => 'application/json'
        expect(response.status).to eq(201)
      end

      it 'response header has tokens' do
        post "/api/v1/users/login", @api_key.to_json, 'CONTENT_TYPE' => 'application/json'
        expect(response.headers['Access-Token']).to eq @login_user.api_keys.last.access_token
      end
    end

    context 'abnormal' do
      it 'return 404' do
        @api_key[:firebase_uid] = nil
        post "/api/v1/users/login",@api_key.to_json , 'CONTENT_TYPE' => 'application/json'
        expect(response.status).to eq(404)
      end

      it 'return 400' do
        post "/api/v1/users/login", 'CONTENT_TYPE' => 'application/json'
        expect(response.status).to eq(400)
      end

    end
  end

  describe 'post /signup' do
    # TODO thumbnail url type_flag
    before do
      @statuses = {name:"AAA",
                   home:"BBB",
                   bio: "CCC",
                   mc_flag: true,
                   dj_flag: true,
                   trackmaker_flag: true,
                   firebase_uid:"DDD",
                   thumbnail: "https://1.bp.blogspot.com/-GqgqXly7B7E/WJmxcNC2s7I/AAAAAAABBmc/8gC8azTAg8Ioxsi8JFqx1s6NY6A8B3UyACLcB/s400/ufo_ushi.png",
                   twitter_account:"aaa"}

    end
    context 'normal' do
      it 'return status 201' do
        post "/api/v1/users/signup", @statuses.to_json, 'CONTENT_TYPE' => 'application/json'
        expect(response.status).to eq(201)
      end

      it 'response header has tokens' do
        post "/api/v1/users/signup", @statuses.to_json, 'CONTENT_TYPE' => 'application/json'
        expect(response.headers['Access-Token']).to eq(ApiKey.
                                                       find_by(firebase_uid: @statuses[:firebase_uid]).access_token)
      end

      it 'create a user correctly' do
        post "/api/v1/users/signup", @statuses.to_json, 'CONTENT_TYPE' => 'application/json'
        user = User.last
        expect(user.name).to eq(@statuses[:name])
        expect(user.home).to eq(@statuses[:home])
        expect(user.bio).to eq(@statuses[:bio])
        expect(user.api_keys.last.firebase_uid).to eq(@statuses[:firebase_uid])
        expect(user.twitter_account).to eq(@statuses[:twitter_account])
        expect(user.mc?).to be true
        expect(user.dj?).to be true
        expect(user.trackmaker?).to be true
        expect(user.thumbnail.url).to eq("/uploads/user/#{user.id}/ufo_ushi.png")
      end
    end

    context 'abnormal' do
      it 'return status 400' do
        @statuses[:name] = nil
        post "/api/v1/users/signup", @statuses.to_json, 'CONTENT_TYPE' => 'application/json'
        expect(response.status).to eq(400)
      end
    end
  end

  describe 'authenticate!' do
    before do
      @existing_user = create(:user, :with_api_key)
      @community = create(:community)
      @headers = {'Access-Token' => @existing_user.api_keys.last.access_token}
    end

    context 'normal' do
      it 'return 200' do
        get "/api/v1/communities/#{@community.id}", headers: @headers
        expect(response.status).to eq(200)
      end
    end

    context 'abnormal' do
      it 'return 401(token not found)' do
        @headers['Access-Token'] = nil
        get "/api/v1/communities/#{@community.id}", headers: @headers
        expect(response.status).to eq(401)
      end

      it 'return 401(token already expired)' do
        @existing_user.api_keys.last.update_attributes(expires_at: DateTime.now.ago(60.days))
        get "/api/v1/communities/#{@community.id}", headers: @headers
        expect(response.status).to eq(401)
      end
    end
  end

  describe 'get /users/:id' do
    before do
      @current_user = create(:user, :with_api_key)
      @headers = {'Access-Token' => @current_user.api_keys.last.access_token}
      @user = create(:user)
    end
    context 'normal' do
      it 'return 200' do
        get "/api/v1/users/#{@user.id}", headers: @headers
        expect(response.status).to eq(200)
      end

      it 'matches data-type pattern' do
        pattern ={
            user: {
                id:                         Integer,
                name:                       String,
                home:                       String,
                bio:                        String,
                twitter_account:            String,
                facebook_account:           String,
                google_account:             String,
                type:   {   mc_flag:          Boolean,
                            dj_flag:          Boolean,
                            trackmaker_flag:  Boolean
                },
                participating_cyphers:      Array,
                participating_communities:  Array,
                thumbnail_url:              String
            }
        }

        get "/api/v1/users/#{@user.id}", headers: @headers
        expect(response.body).to match_json_expression(pattern)
      end

      it 'matches data-content pattern' do
        temp_community = create(:community,
                                :with_cypher)

        @user.participating_communities << temp_community

        temp_cyphers = temp_community.cyphers.
                                        where('cypher_from >= ?', Date.today.to_datetime).
                                        order(:cypher_from)
        temp_cyphers.each do |c|
          @user.participating_cyphers << c
        end
        pattern ={
            user:{
                id:                         @user.id,
                name:                       @user.name,
                home:                       @user.home,
                bio:                        @user.bio,
                twitter_account:            @user.twitter_account,
                facebook_account:           @user.facebook_account,
                google_account:             @user.google_account,
                type:   {   mc_flag:          @user.mc?,
                            dj_flag:          @user.dj?,
                            trackmaker_flag:  @user.trackmaker?
                },
                participating_cyphers:      [
                    {id:  temp_cyphers[0].id}.ignore_extra_keys!,
                    {id:  temp_cyphers[1].id}.ignore_extra_keys!,
                    {id:  temp_cyphers[2].id}.ignore_extra_keys!
                ],
                participating_communities:  [
                    {id:  temp_community.id}.ignore_extra_keys!
                ],
                thumbnail_url:              @user.thumbnail.url
            }
        }

        get "/api/v1/users/#{@user.id}", headers: @headers
        expect(response.body).to match_json_expression(pattern)
      end
    end

    context 'abnormal' do
      it 'wrong type of parameter' do
        get '/api/v1/users/a', headers: @headers
        expect(response.status).to eq(400)
      end

      it 'user not found' do
        get '/api/v1/users/9999', headers: @headers
        expect(response.status).to eq(404)
      end
    end
  end
end