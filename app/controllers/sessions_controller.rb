class SessionsController < ApplicationController
  def new

  end

  def create
    user = User.find_by username: params[:username]
    if user && user.authenticate(params[:password]) && !user.froze
      session[:user_id] = user.id
      redirect_to user_path(user), notice: "Welcome back, #{user.username}!"
    elsif user && user.froze
      redirect_to :back, notice: "Your account has been frozen, please contact admin"
    else
      redirect_to :back, notice: "Username and/or password mismatch"
    end
  end

  def create_oauth
    auth = request.env["omniauth.auth"].info
    user = User.find_by(:username => auth["nickname"] + " GH") || User.create_with_omniauth(auth)
    if user && !user.froze
      session[:user_id] = user.id
      redirect_to  user_path(user), notice: "Welcome back, #{user.username}!"
    elsif user && user.froze
      redirect_to :back, notice: "Your account has been frozen, please contact admin"
    else
      redirect_to :back, notice: "Can't login with Github"
    end
  end


  def destroy
    session[:user_id] = nil
    redirect_to :root
  end
end