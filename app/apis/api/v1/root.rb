module API
  module V1
    class Root < Grape::API
      version 'v1', using: :path
      format :json

      mount API::V1::Communities
    end
  end
end