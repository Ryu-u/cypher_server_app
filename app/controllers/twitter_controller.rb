class TwitterController < ApplicationController
  def callback
    #TODO callbackにはユーザー作成パターンと有効期限切れ後ログインパターンがある
    #有効期限切れ後ログインパターンも作る
    key = ApiKey.find_by(twitter_uid: request.env['omniauth.auth'][:uid])
    if key.nil?
      session[:uid] = request.env['omniauth.auth'][:uid]
      session[:name] = request.env['omniauth.auth'][:info][:name]
      session[:nickname] = request.env['omniauth.auth'][:info][:nickname]
      session[:bio] = request.env['omniauth.auth'][:info][:description]

      redirect_to new_user_path
    else
      key.update_attributes(access_token: SecureRandom.hex,
                            expires_at: DateTime.now+30
                           )
      cookies.permanent[:access_token] = key.access_token
      redirect_to '/'
    end
  end
end
