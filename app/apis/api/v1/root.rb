module API
  module V1
    class Root < Grape::API
      version 'v1', using: :path
      format :json

      helpers do
        def authenticate!
          if !current_user
            error!('Unauthorized. Invalid or expired token.', 401)
          else
            true
          end
        end

        def current_user
          token = ApiKey.where(access_token: request.headers['Access-Token']).last
          if token && !token.expired?
            @current_user = User.find(token.user_id)
          else
            false
          end
        end
      end

      rescue_from ActiveRecord::RecordNotFound do |e|
        error!({ error: 'Not Found', detail: "#{e.message}" }, 404)
      end

      rescue_from Grape::Exceptions::ValidationErrors do |e|
        # TODO エラーメッセージ考える
        error!({ error: 'parameter is invalid',
                 detail: "#{e.message}" },
                 400)
      end

      rescue_from :all do |e|
        error!({ error: 'Internal server error',
                 detail: "#{e.message}" },
                 500)
      end

      mount API::V1::Communities
      mount API::V1::Users

      route :any, '*path' do
        error!({ error:  'Route Not Found',
                 detail: "No such route '#{request.path}'"},
               500)
      end

      route :any do
        error!({ error:  'Route Not Found',
                 detail: "No such route '#{request.path}'"},
               500)
      end
    end
  end
end