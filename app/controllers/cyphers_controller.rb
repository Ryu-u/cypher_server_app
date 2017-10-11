class CyphersController < ApplicationController
  include GeneralHelper

  def index
    authenticate!
    all_cyphers = Cypher.
        includes(:community).
        where.has{|cypher| (cypher.cypher_to > DateTime.now)}
    @cyphers = all_cyphers.
        ordering{|cypher| [cypher.cypher_from.asc, cypher.id.asc]}.
        page(params[:page])
  end

  def show
    authenticate!
    @cypher = Cypher.find(params[:id])
  end

  def new
    authenticate!
    #TODO コミュニティのホストかどうか
    community_name = Community.find(params[:id]).name
    @cypher = Cypher.new(name: community_name)
  end

  def create
    authenticate!
    #TODO コミュニティのホストかどうか
    params = cypher_params
    community = Community.find(params[:id])
    @cypher = Cypher.new(name: params[:name],
                         place: params[:place],
                         info: params[:ifno],
                         cypher_from: params[:cypher_from],
                         cypher_to: params[:cypher_to])
    community.cyphers << @cypher
    @cypher.host = @current_user
    if @cypher.save!
      redirect_to @cypher
    else
      render 'new'
    end
  end

  def edit
    authenticate!
    #TODO サイファーのホストかどうか
    @cypher = Cypher.find(params[:id])
  end

  def update
    authenticate!
    #TODO サイファーのホストかどうか
    params = cypher_params
    @cypher.name = params[:name]
    @cypher.place = params[:place]
    @cypher.info = params[:ifno]
    @cypher.cypher_from = params[:cypher_from]
    @cypher.cypher_to = params[:cypher_to]
    if @cypher.save!
      redirect_to @cypher
    else
      render 'edit'
    end

  end

  def destroy
    authenticate!
    #TODO サイファーのホストかどうか
    @cypher = Cypher.find(params[:id])
    @cypher.destroy!
    # render 成功ページへ
  end

  def my_cyphers
    if authenticate!
    all_cyphers = @current_user.participating_cyphers.
        where.has{|cypher| (cypher.cypher_to > DateTime.now)}
    @cyphers = all_cyphers.
        ordering{|cypher| [cypher.cypher_from.asc, cypher.id.asc]}.
        page(params[:page])
    else
      redirect_to '/auth/twitter'
    end
  end

  def hosting_cyphers
    authenticate!
    all_cyphers = @current_user.hosting_cyphers.
        where.has{|cypher| (cypher.cypher_to > DateTime.now)}
    @cyphers = all_cyphers.
        ordering{|cypher| [cypher.cypher_from.asc, cypher.id.asc]}.
        page(params[:page])
  end

  private

  def cypher_params
    params.require(:cypher).permit(:name,
                                   :place,
                                   :info,
                                   :cypher_from,
                                   :cypher_to)
  end
end
