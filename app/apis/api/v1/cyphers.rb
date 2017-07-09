module API
  module V1
    class Cyphers < Grape::API
      format :json
      formatter :json, Grape::Formatter::Jbuilder

      resource :home do
        params do
          requires :page, type: Integer
        end

        get '/', jbuilder: 'v1/cypher_summary' do
          authenticate!
          @cyphers = Cypher.
                        where(Cypher.arel_table[:cypher_from].gteq DateTime.now).
                        order("cyphers.cypher_from DESC").
                        page(params[:page])
          @cyphers_total = Cypher.
                              where(Cypher.arel_table[:cypher_from].gteq DateTime.now).count
          @current_page = params[:page]
        end
      end

      resource :cyphers do
        params do
          requires :id, type: Integer
        end

        get '/:id', jbuilder: 'v1/cypher' do
          authenticate!
          @cypher = Cypher.find(params[:id])
        end
      end

      resource :participating_cyphers do
        params do
          requires :page, type: Integer
        end

        get '/', jbuilder: 'v1/cypher_summary' do
          authenticate!
          @cyphers = @current_user.
                          participating_cyphers.
                          joins(:cypher_participants).
                          includes(:cypher_participants).
                          where(Cypher.arel_table[:cypher_from].gteq DateTime.now).
                          order("cyphers.cypher_from DESC").
                          page(params[:page])
          @cyphers_total = @current_user.
                                participating_cyphers.count
          @current_page = params[:page]
        end
      end

      resource :hosting_cyphers do
        params do
          requires :page, type: Integer
        end

        get '/', jbuilder: 'v1/cypher_summary' do
          authenticate!
          @cyphers = @current_user.
                          hosting_cyphers.
                          where(Cypher.arel_table[:cypher_from].gteq DateTime.now).
                          order("cyphers.cypher_from DESC").
                          page(params[:page])
          @cyphers_total = @current_user.
                                hosting_cyphers.count
          @current_page = params[:page]
        end
      end
    end
  end
end
