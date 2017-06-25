require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe 'get /login' do
    before do
      @login_user = create(:user, :with_api_key)
    end
    context 'token does not expire' do
      it 'return 200 OK' do
        get "/api/v1/users/login", params: {firebase_uid: @login_user.api_keys.first.firebase_uid}
        expect(response.status).to eq(201)
      end

      it 'response header has tokens' do
        get "/api/v1/users/login", params: {firebase_uid: @login_user.api_keys.first.firebase_uid}
        expect(response.headers['Access-Token']).to eq @login_user.api_keys.last.access_token
      end
    end

  end
end