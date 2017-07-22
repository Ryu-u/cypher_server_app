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

        desc 'コミュニティ作成'
        params do
          requires :name,               type: String
          requires :home,               type: String
          requires :bio,                type: String
          optional :twitter_account,    type: String
          optional :facebook_account,   type: String
          optional :thumbnail,          type: String
        end

        post '/' do
          authenticate!
          @community = Community.new(
              name:              params[:name],
              home:              params[:home],
              bio:               params[:bio],
              twitter_account:   params[:twitter_account],
              facebook_account:  params[:facebook_account],
          )
          @community.remote_thumbnail_url = params[:thumbnail]
          @current_user.hosting_communities << @community
          if @community.save!
            status :created
          end
        end

        desc 'コミュニティ編集'
        params do
          requires :id,                 type: Integer
          requires :name,               type: String
          requires :home,               type: String
          requires :bio,                type: String
          optional :twitter_account,    type: String
          optional :facebook_account,   type: String
          optional :thumbnail,          type: String
        end

        put '/:id' do
          authenticate!
          @community = Community.find(params[:id])
          if @current_user.hosting_community?(@community.id)
            @community.update_attributes(
                name:              params[:name],
                home:              params[:home],
                bio:               params[:bio],
                twitter_account:   params[:twitter_account],
                facebook_account:  params[:facebook_account],
                thumbnail:         params[:thumbnail]
            )
          else
            status :conflict
          end
        end

        desc 'コミュニティ削除'
        params do
          requires :id , type: Integer
        end

        delete '/:id' do
          authenticate!
          @community = Community.find(params[:id])
          if @current_user.hosting_community?(@community.id)
            @community.destroy!
          else
            status :conflict
          end
        end

        desc 'サイファー作成'
        params do
          requires :community_id,  type: Integer
          requires :name,         type: String
          requires :info,         type: String
          requires :cypher_from,  type: DateTime
          requires :cypher_to,    type: DateTime
          requires :place,        type: String
          optional :capacity,     type: Integer
        end

        post '/:community_id/cyphers' do
          authenticate!
          @community = Community.find(params[:community_id])
          if @current_user.hosting_community?(@community.id)
            # 作成成功
            cypher = Cypher.new(
                name:         params[:name],
                info:         params[:info],
                cypher_from:  params[:cypher_from],
                cypher_to:    params[:cypher_to],
                place:        params[:place],
                capacity:     params[:capacity]
            )
            @community.cyphers << cypher
            @current_user.hosting_cyphers << cypher

            max_serial_num = Cypher.where(name: params[:name]).
                maximum(:serial_num)
            if max_serial_num
              cypher.serial_num = max_serial_num + 1
            else
              cypher.serial_num = 1
            end

            if cypher.save!
              status :created
            end

          else
            # 作成失敗
            status :conflict
          end
        end
      end


      desc '参加コミュニティ一覧表示'
      resource :my_communities do
        params do
          requires :since_id, type: Integer
        end

        get '/', jbuilder: 'v1/community_summary' do
          authenticate!
          all_communities = @current_user.
              participating_communities.
              joins(:community_participants).
              includes(:community_participants).
              where(["communities.id > :since_id",
                     {since_id: params[:since_id]}]).
              order("communities.id ASC")
          @communities = all_communities.limit(20)
          @communities_total = @current_user.
              participating_communities.count
        end
      end

      desc '主催コミュニティ一覧表示'
      resource :hosting_communities do
        params do
          requires :since_id, type: Integer
        end

        get '/', jbuilder: 'v1/community_summary' do
          authenticate!
          all_communities = @current_user.
              hosting_communities.
              where(["communities.id > :since_id",
                     {since_id:    params[:since_id]}]).
              order("communities.id ASC")
          @communities = all_communities.limit(20)
          @communities_total = @current_user.
              hosting_communities.count
        end
      end

      desc 'フォロー中のコミュニティ一覧表示'
      resource :following_communities do
        params do
          requires :since_id, type: Integer
        end

        get '/', jbuilder: 'v1/community_summary' do
          authenticate!
          all_communities = @current_user.
              following_communities.
              joins(:community_followers).
              includes(:community_followers).
              where(["communities.id > :since_id",
                     {since_id:    params[:since_id]}]).
              order("communities.id ASC")
          @communities = all_communities.limit(20)
          @communities_total = @current_user.
              following_communities.count
        end
      end
    end
  end
end