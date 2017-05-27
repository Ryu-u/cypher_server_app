module API
  module V1
    class Communities < Grape::API
      format :json
      formatter :json, Grape::Formatter::Jbuilder

      resource :communities do

        desc 'コミュニティ詳細取得'
        params do
          requires :id, type: Integer
          optional :since_id, type: Integer
          optional :limit, type: Integer
        end
        get '/:id', jbuilder: 'v1/community' do
          @community = Community.find(params[:id])
        end


        get '/my_communities/:id', jbuilder: 'v1/community_summary' do
          @communities = CommunityParticipant.
                          where(participant_id: params[:id]).
                          order(created_at: :desc).
                          limit(params[:limit]).
                          offset(params[:since_id]).
                          Communities.all
        end
      end

    end
  end
end