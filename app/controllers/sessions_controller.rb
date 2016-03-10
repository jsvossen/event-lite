class SessionsController < ApplicationController

	def new
		redirect_to current_user if logged_in?
	end

	def create
		user = User.find_by(email: params[:session][:email])
		if user # && @user.authenticate?
			log_in(user)
			flash[:success] = "Welcome back!"
			redirect_to root_path
		else
			flash.now[:danger] = "Email address not found."
			render :new
		end
	end

	def destroy
		log_out if logged_in?
		flash[:success] = "You have logged out."
		redirect_to login_path
	end

end
