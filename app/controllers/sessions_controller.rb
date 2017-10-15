class SessionsController < ApplicationController
  def logout
    cookies.delete(:access_token)
    redirect_to '/'
  end
end
