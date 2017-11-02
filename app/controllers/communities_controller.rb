class CommunitiesController < ApplicationController
  include GeneralHelper

  def show
    authenticate!
    @community = Community.find(params[:id])
    @past_cyphers = @community.cyphers.
        where('cypher_from < ?', Date.today.to_datetime).
        order(cypher_from: :desc).all
    @future_cyphers = @community.cyphers.
        where('cypher_from >= ?', Date.today.to_datetime).
        order(:cypher_from).all
  end

  def my_communities
    
    authenticate!
    all_communities = @current_user.
        participating_communities
    # TODO 普通にページネーションでよくない？
        #.
        #joins(:community_participants).
        #includes(:community_participants).
        #where(["communities.id > :since_id",
        #       {since_id: params[:since_id]}]).
        #order("communities.id ASC")
    @communities = all_communities.limit(20)
    @communities_total = @current_user.
        participating_communities.count
  end

  def hosting_communities

    authenticate!
    all_communities = @current_user.
        hosting_communities
        #.
        #where(["communities.id > :since_id",
        #       {since_id:    params[:since_id]}]).
        #order("communities.id ASC")
    @communities = all_communities.limit(20)
    @communities_total = @current_user.
        hosting_communities.count
  end

  def following_communities
    
    authenticate!
    all_communities = @current_user.
        following_communities
        #.
        #joins(:community_followers).
        #includes(:community_followers).
        #where(["communities.id > :since_id",
        #       {since_id:    params[:since_id]}]).
        #order("communities.id ASC")
    @communities = all_communities.limit(20)
    @communities_total = @current_user.
        following_communities.count
  end

  def new
    authenticate!
    @community = Community.new
  end

  def create
    authenticate!
    @community = Community.new(community_params)
    if @community.save
      @current_user.hosting_communities << @community
      redirect_to @community
    else
      render 'new'
    end
  end

  def edit
    authenticate!
    @community = Community.find(params[:id])
    if @current_user.hosting_community?(@community.id)
      render 'edit'
    else
      redirect_to @community
    end
  end

  def update
    authenticate!
    if @current_user.hosting_community?(params[:id])
      @community = Community.find(params[:id])
      if @community.update_attributes(community_params)
        redirect_to @community
      else
        render 'edit'
      end
    else
      redirect_to @community
    end
  end

  def destroy
    authenticate!
    if @current_user.hosting_community?(params[:id])
      @community = Community.find(params[:id])
      if @community.destroy!
        redirect_to '/'
        # 成功メッセージ
      end
    else
      # TODO 失敗メッセージ
    end
  end

  def participate_in
    if authenticate!
      community = Community.find(params[:community_id])
      if @current_user.participating_communities << community
        status 200
      else
        status 400
      end
    end
  end

  def leave
    if authenticate!

    end
  end

  private

  def community_params
    params.require(:community).permit(:name,
                                      :home,
                                      :bio,
                                      :twitter_acocunt,
                                      :thumbnail)
  end
end
