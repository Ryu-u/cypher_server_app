module API
  module V1
    class Root < Grape::API
      version 'v1', using: :path
      format :json

      rescue_from ActiveRecord::RecordNotFound do |e|
        error!({ error: 'Not Found', detail: "#{e.message}" }, 404)
      end

      rescue_from Grape::Exceptions::ValidationErrors do |e|
        error!({ error: 'Community id is invalid',
                 detail: "#{e.message}" },
               400)
      end

      rescue_from :all do |e|
        error!({ error: 'Internal server error',
                 detail: "#{e.message}" },
               500)
      end

      mount API::V1::Communities

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