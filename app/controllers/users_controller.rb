class UsersController < ApplicationController
	
	def new
		redirect_to current_user if logged_in?
		@user = User.new
	end

	def create
		@user = User.new(user_params)
		if @user.save
			flash[:success] = "Welcome, #{@user.name}!"
			redirect_to @user
			log_in(@user)
		else
			render :new
		end
	end

	def show
		@user = User.find(params[:id])
		@created_events = @user.events.order(date: :desc)
		@upcoming_events = @user.attended_events.upcoming
		@past_events = @user.attended_events.past
	end


	private

		def user_params
			params.require(:user).permit(:name, :email)
		end

end
