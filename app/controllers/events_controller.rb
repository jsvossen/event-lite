class EventsController < ApplicationController

	before_action :logged_in_user, only: [:create, :new]

	def new
		@event = Event.new
	end

	def create
		@event = current_user.events.build(event_params)
		if @event.save
			host_invite = @event.invites.build(attendee_id: @event.creator.id)
			flash[:danger] = "Error inviting host" unless host_invite.save
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
		@invite_user = Invite.new if logged_in? && @creator == current_user
		@attendees = @event.attendees
	end

	def index
		@past_events = Event.past
		@future_events = Event.upcoming
	end


	private

		def event_params
			params.require(:event).permit(:title, :location, :date, :description, :creator_id, :private)
		end

end
