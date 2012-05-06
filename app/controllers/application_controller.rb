class ApplicationController < ActionController::Base
  protect_from_forgery
  
  
  helper_method :user, :user_logged?
  
  def user
    @user ||= 
      Author.where(:id => session[:user_id]).first if session[:user_id]
  end
  
  alias :current_user :user
  
  def user_logged?
    user.present?
  end
  
  alias :current_user_logged? :user_logged?
end
