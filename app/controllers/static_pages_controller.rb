class StaticPagesController < ApplicationController

	def home
		if logged_in?
			@events = current_user.attended_events.upcoming
		else
			@events = Event.upcoming
		end
	end

end
