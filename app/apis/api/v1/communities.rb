module API
  module V1
    class Communities < Grape::API
      format :json
      formatter :json, Grape::Formatter::Jbuilder

      resource :communities do
        desc 'コミュニティ詳細取得'
        params do
          requires :id, type: Integer
        end

        get '/:id', jbuilder: 'v1/community' do
          authenticate!
          @community = Community.find(params[:id])
          @past_cyphers = @community.cyphers.
                                      where('cypher_from < ?', Date.today.to_datetime).
                                      order(cypher_from: :desc).all
          @future_cyphers = @community.cyphers.
                                      where('cypher_from >= ?', Date.today.to_datetime).
                                      order(:cypher_from).all
        end
      end
      resource :my_communities do
        params do
          requires :page, type: Integer
        end

        get '/', jbuilder: 'v1/community_summary' do
          authenticate!
          @communities = @current_user.
                              participating_communities.
                              joins(:community_participants).
                              includes(:community_participants).
                              order("community_participants.created_at DESC").
                              page(params[:page])
          @communities_total = @current_user.
                                  participating_communities.count
          @current_page = params[:page]
        end
      end

      resource :hosting_communities do
        params do
          requires :page, type: Integer
        end

        get '/', jbuilder: 'v1/community_summary' do
          authenticate!
          @communities = @current_user.
                              hosting_communities.
                              joins(:community_hosts).
                              includes(:community_hosts).
                              order("community_hosts.created_at DESC").
                              page(params[:page])
          @communities_total = @current_user.
                                    hosting_communities.count
          @current_page = params[:page]
        end
      end

      resource :following_communities do
        params do
          requires :page, type: Integer
        end

        get '/', jbuilder: 'v1/community_summary' do
          authenticate!
          @communities = @current_user.
                              following_communities.
                              joins(:community_followers).
                              includes(:community_followers).
                              order("community_followers.created_at DESC").
                              page(params[:page])
          @communities_total = @current_user.
                                  following_communities.count
          @current_page = params[:page]
        end
      end
    end
  end
end