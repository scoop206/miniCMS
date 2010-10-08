class UserSessionsController < ApplicationController
  layout "login"
  
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => :destroy
  
  def new
    @user_session = UserSession.new
  end
  
  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      redirect_back_or_default('/admin')
    else
      redirect_to new_user_session_url
    end
  end
  
  def destroy
    current_user_session("admin").destroy
    flash[:notice] = "Logout successful!"
    redirect_to new_user_session_url
  end
end
