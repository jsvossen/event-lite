class EventsController < ApplicationController

	before_action :logged_in_user, only: [:create, :new]

	def new
		@event = Event.new
	end

	def create
		@event = current_user.events.build(event_params)
		if @event.save
			flash[:success] = "Event created!"
			redirect_to @event
		else
			render :new
		end
	end

	def show
		@event = Event.find(params[:id])
		@creator = User.find(@event.creator_id)
		@invite = @event.invites.where(attendee_id: current_user.id).first || Invite.new if logged_in?
		@attendees = @event.attendees
	end

	def index
		@past_events = Event.past
		@future_events = Event.upcoming
	end


	private

		def event_params
			params.require(:event).permit(:title, :location, :date, :description, :creator_id)
		end

end
