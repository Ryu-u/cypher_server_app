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
    @community = Community.find(params[:id])
    if @current_user.hosting_community?(@community.id)
      @cypher = Cypher.new(name: @community.name)
    else
      redirect_to @community
    end
  end

  def create
    authenticate!
    @community = Community.find(params[:id])
    if @current_user.hosting_community?(@community.id)
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
    else
      redirect_to @community
    end
  end

  def edit
    authenticate!
    @cypher = Cypher.find(params[:id])
    if @current_user.hosting_cypher?(params[:id])
      @cypher
    else
      redirect_to @cypher
    end
  end

  def update
    authenticate!
    @cypher = Cypher.find(params[:id])
    if @current_user.hosting_cypher?(@cypher.id)
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
    else
      redirect_to @cypher
    end
  end

  def destroy
    authenticate!
    @cypher = Cypher.find(params[:id])
    if @current_user.hosting_cypher?(@cypher.id)
    @cypher.destroy!
    # render 成功ページへ
    end
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
