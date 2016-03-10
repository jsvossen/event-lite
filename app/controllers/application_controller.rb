class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user, :logged_in?

  def log_in(user)
  	session[:user_id] = user.id
  	current_user = user
  end

  def current_user
  	@current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def current_user=(user)
  	@current_user = user
  end

  def logged_in?
  	!current_user.nil?
  end

  def log_out
  	session.delete(:user_id)
  	current_user = nil
  end

  private

    def logged_in_user
      unless logged_in?
        flash[:danger] = "Please log in."
        redirect_to login_path
      end
    end

end
