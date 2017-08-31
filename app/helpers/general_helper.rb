module GeneralHelper
  def authencticate!
    # アクセストークンを用いての認証メソッド
    def authenticate!
      if !current_user
        error!('Unauthorized. Invalid or expired token.', 401)
      else
        true
      end
    end

    # アクセスしてくるユーザーがサインアップ済か検証するメソッド
    def current_user
      token = ApiKey.where(access_token: request.headers['Access-Token']).last
      if token && !token.expired?
        @current_user = User.find(token.user_id)
      else
        false
      end
    end
  end
end
