module API
  module V1
    class Cyphers < Grape::API
      format :json
      formatter :json, Grape::Formatter::Jbuilder

      resource :cyphers do
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

          all_cyphers = Cypher.
                            includes(:community).
                            where.has{|cypher| (cypher.cypher_from > cypher_from) |
                            (cypher.id > params[:since_id]) & (cypher.cypher_from == cypher_from)}


          @cyphers = all_cyphers.
                              ordering{|cypher| [cypher.cypher_from.asc, cypher.id.asc]}.
                              limit(20)
          @cyphers_total = Cypher.where.has{|cypher| (cypher.cypher_from > DateTime.now)}.count
        end

        params do
          requires :id, type: Integer
        end

        get '/:id', jbuilder: 'v1/cypher' do
          authenticate!
          @cypher = Cypher.find(params[:id])
        end

        params do
          requires :since_id,     type: Integer
          requires :cypher_from,  type: DateTime
        end
        get '/:id/posts' do
          # TODO 実装待ち
        end
      end

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
