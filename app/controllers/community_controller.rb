class CommunityController < ApplicationController
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
    authencticate!
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

  def hosting_communities
    authencticate!
    all_communities = @current_user.
        hosting_communities.
        where(["communities.id > :since_id",
               {since_id:    params[:since_id]}]).
        order("communities.id ASC")
    @communities = all_communities.limit(20)
    @communities_total = @current_user.
        hosting_communities.count
  end

  def following_communities
    authencticate!
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
