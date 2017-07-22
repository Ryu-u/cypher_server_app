module API
  module V1
    class Cyphers < Grape::API
      format :json
      formatter :json, Grape::Formatter::Jbuilder


      resource :cyphers do
        desc 'サイファー一覧表示'
        params do
          requires :since_id,     type: Integer
          requires :cypher_from,  type: DateTime
        end

        get '/', jbuilder: 'v1/cypher_summary' do
          authenticate!
          if params[:cypher_from].present?
            cypher_from = params[:cypher_from]
          else
            cypher_from = DateTime.now
          end

          # kaminariじゃなくて、サイファー開始時刻とidでページネーションを実装
          all_cyphers = Cypher.
              includes(:community).
              where.has{|cypher| (cypher.cypher_from > cypher_from) |
              (cypher.id > params[:since_id]) & (cypher.cypher_from == cypher_from)}

          @cyphers = all_cyphers.
              ordering{|cypher| [cypher.cypher_from.asc, cypher.id.asc]}.
              limit(20)
          @cyphers_total = Cypher.where.has{|cypher| (cypher.cypher_from > DateTime.now)}.count
        end

        desc 'サイファー詳細取得'
        params do
          requires :id, type: Integer
        end

        get '/:id', jbuilder: 'v1/cypher' do
          authenticate!
          @cypher = Cypher.find(params[:id])
        end

        desc 'サイファー情報更新'
        params do
          requires :id,           type: Integer
          requires :name,         type: String
          requires :info,         type: String
          requires :cypher_from,  type: DateTime
          requires :cypher_to,    type: DateTime
          requires :place,        type: String
          optional :capacity,     type: Integer
        end
        put '/:id' do
          authenticate!
          @cypher = Cypher.find(params[:id])
          if @current_user.hosting_cypher?(@cypher.id)
            cypher = @cypher.update_attributes(
                name:         params[:name],
                info:         params[:info],
                cypher_from:  params[:cypher_from],
                cypher_to:    params[:cypher_to],
                place:        params[:place],
                capacity:     params[:capacity]
            )
          else
            status :conflict
          end
        end

        desc 'サイファー削除'
        params do
          requires :id,  type: Integer
        end

        delete '/:id' do
          authenticate!
          @cypher = Cypher.find(params[:id])
          if @current_user.hosting_cypher?(@cypher.id)
            @cypher.destroy!
          else
            status :conflict
          end
        end
      end

      desc '参加サイファー一覧表示'
      resource :participating_cyphers do
        params do
          requires :since_id,     type: Integer
          requires :cypher_from,  type: DateTime
        end
       get '/', jbuilder: 'v1/cypher_summary' do
          authenticate!
          if params[:cypher_from].present?
            cypher_from = params[:cypher_from]
          else
            cypher_from = DateTime.now
          end
         all_cyphers = @current_user.
              participating_cyphers.
              includes(:community).
              where.has{|cypher| (cypher.cypher_from > cypher_from) |
              (cypher.id > params[:since_id]) & (cypher.cypher_from == cypher_from)}
         @cyphers = all_cyphers.
              ordering{|cypher| [cypher.cypher_from.asc, cypher.id.asc]}.
              limit(20)
          @cyphers_total = all_cyphers.count
       end
      end
     desc 'ホスト中のサイファー表示'
      resource :hosting_cyphers do
        params do
          requires :since_id,     type: Integer
          requires :cypher_from,  type: DateTime
        end
       get '/', jbuilder: 'v1/cypher_summary' do
          authenticate!
          if params[:cypher_from].present?
            cypher_from = params[:cypher_from]
          else
            cypher_from = DateTime.now
          end
         all_cyphers = @current_user.
              hosting_cyphers.
              includes(:community).
              where.has{|cypher| (cypher.cypher_from > cypher_from) |
              (cypher.id > params[:since_id]) & (cypher.cypher_from == cypher_from)}
         @cyphers = all_cyphers.
              ordering{|cypher| [cypher.cypher_from.asc, cypher.id.asc]}.
              limit(20)
          @cyphers_total = all_cyphers.count
        end
      end
    end
  end
end

