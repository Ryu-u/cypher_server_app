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
                   type_flag:1,
                   firebase_uid:"DDD",
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
        expect(user.type_flag).to eq(@statuses[:type_flag])
        expect(user.api_keys.last.firebase_uid).to eq(@statuses[:firebase_uid])
        expect(user.twitter_account).to eq(@statuses[:twitter_account])
      end
    end

    context 'abnormal' do
      it 'return status 500' do
        @statuses[:name] = nil
        post "/api/v1/users/signup", @statuses.to_json, 'CONTENT_TYPE' => 'application/json'
        expect(response.status).to eq(500)
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
end