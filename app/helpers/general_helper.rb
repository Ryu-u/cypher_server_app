module GeneralHelper
  def authenticate!
    if !current_user
       false
    else
      true
    end
  end
  # アクセスしてくるユーザーがサインアップ済か検証するメソッド
  def current_user
    token = ApiKey.find_by(access_token: cookies[:access_token])
    if token && !token.expired?
      @current_user = User.find(token.user_id)
    else
      false
    end
  end
end
