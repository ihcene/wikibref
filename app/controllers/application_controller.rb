class ApplicationController < ActionController::Base
  protect_from_forgery
  
  
  helper_method :user, :user_logged?
  
  def user
    @user ||= 
      Author.where(:id => session[:author_id]).first if session[:author_id]
  end
  
  alias :current_user :user
  
  def user_logged?
    user.present?
  end
  
  alias :current_user_logged? :user_logged?
end
