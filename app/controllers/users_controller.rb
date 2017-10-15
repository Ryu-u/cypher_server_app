class UsersController < ApplicationController
  include GeneralHelper

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new(name: session[:name],
                            bio: session[:bio],
                            twitter_account: session[:nickname])
  end

  def create
    params = user_params
    @user = User.new(name: params[:name],
                     home: params[:home],
                     bio: params[:bio]
                     )
    @user.mc = true if params[:mc]
    @user.dj = true if params[:dj]
    @user.trackmaker = true if params[:trackmaker]
    @user.twitter_account = session[:nickname]
    api_key = ApiKey.new(twitter_uid: session[:uid])
    @user.api_key = api_key
    if @user.save!
      reset_session
      cookies.permanent[:access_token] = @user.api_key.access_token

      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
    authenticate!

  end

  def update
    authenticate!
    params = user_params
    @current_user.name =  params[:name]
    @current_user.home = params[:home]
    @current_user.bio = params[:bio]
    @current_user.mc = true if params[:mc]
    @current_user.dj = true if params[:dj]
    @current_user.trackmaker = true if params[:trackmaker]
    if @current_user.save!
      redirect_to @current_user
    else
      render 'edit'
    end
  end

  def destroy
    authenticate!
    if @current_user.destroy!
      reset_session
      cookies.delete :access_token
      redirect_to '/'
    end
  end

  private

  def user_params
    params.require(:user).permit(:name,
                                 :home,
                                 :bio,
                                 :mc,
                                 :dj,
                                 :trackmaker
                                )
  end
end
