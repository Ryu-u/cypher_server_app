module API
  module V1
    class Users < Grape::API
      version 'v1', using: :path
      format :json

      resource :users do
        params do
            requires :firebase_uid, type: String
        end
        post '/login' do
          trying_user_key = ApiKey.find_by(firebase_uid: params[:firebase_uid])
          if trying_user_key.nil?
            status :not_found
          else
            trying_user = User.find_by(id: trying_user_key.user_id)
            new_key = ApiKey.new(firebase_uid: params[:firebase_uid])
            trying_user.api_keys << new_key
            new_key.save!

            header 'Access-Token',  new_key.access_token


            status :created
          end
        end

        params do
          requires :name,             type: String
          requires :home,             type: String
          requires :bio,              type: String
          requires :type_flag,        type: Integer
          requires :firebase_uid,     type: String
          optional :thumbnail,        type: Hash
          at_least_one_of :twitter_account,
                          :facebook_account,
                          :google_account,
                          type: String
        end
        # TODO thumbnailはcarrierwaveで修正する

        post '/signup' do
          @signup_user = User.create(
                                     name:              params[:name],
                                     home:              params[:home],
                                     bio:               params[:bio],
                                     type_flag:         params[:type_flag],
                                     twitter_account:   params[:twitter_account],
                                     facebook_account:  params[:facebook_account],
                                     google_account:    params[:google_account],
                                     thumbnail_url:     params[:thumbnail]
                                     )
          signup_users_api_key = ApiKey.new(firebase_uid: params[:firebase_uid])
          @signup_user.api_keys << signup_users_api_key
          signup_users_api_key.save!

          header 'Access-Token',  signup_users_api_key.access_token
          status :created
        end

      end
    end
  end
end
