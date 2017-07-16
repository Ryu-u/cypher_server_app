module API
  module V1
    class Users < Grape::API
      version 'v1', using: :path
      formatter :json, Grape::Formatter::Jbuilder

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
          requires :mc_flag,          type: Boolean
          requires :dj_flag,          type: Boolean
          requires :trackmaker_flag,  type: Boolean
          requires :firebase_uid,     type: String
          optional :thumbnail,        type: String
          at_least_one_of :twitter_account,
                          :facebook_account,
                          :google_account,
                          type: String
        end

        post '/signup' do
          @signup_user = User.new(
                                     name:              params[:name],
                                     home:              params[:home],
                                     bio:               params[:bio],
                                     twitter_account:   params[:twitter_account],
                                     facebook_account:  params[:facebook_account],
                                     google_account:    params[:google_account],
                                     )

          @signup_user.remote_thumbnail_url = params[:thumbnail]

          @signup_user.mc         = true if params[:mc_flag]
          @signup_user.dj         = true if params[:dj_flag]
          @signup_user.trackmaker = true if params[:trackmaker_flag]
          @signup_user.save!

          signup_users_api_key = ApiKey.new(firebase_uid: params[:firebase_uid])
          @signup_user.api_keys << signup_users_api_key
          signup_users_api_key.save!

          header 'Access-Token',  signup_users_api_key.access_token
          status :created
        end

        params do
          requires :id , type: Integer
        end

        get '/:id', jbuilder: 'v1/user' do
          authenticate!
          @user = User.find(params[:id])
        end
      end
    end
  end
end
