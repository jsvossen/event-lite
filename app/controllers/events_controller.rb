class EventsController < ApplicationController

	before_action :logged_in_user, only: [:create, :new]

	def new
		@event = Event.new
	end

	def create
		@event = current_user.events.build(event_params)
		if @event.save
			# invite creator if event is private
			if @event.private?
				host_invite = @event.invites.build(attendee_id: @event.creator.id)
				flash[:danger] = "Error inviting host" unless host_invite.save
			end
			flash[:success] = "Event created!"
			redirect_to @event
		else
			render :new
		end
	end

	def show
		@event = Event.find(params[:id])
		@creator = User.find(@event.creator_id)
		# existing or new invite for current user
		@invite = @event.invites.where(attendee_id: current_user.id).first || Invite.new if logged_in?
		# empty invite for private event creator to add attendees
		@invite_user = Invite.new if logged_in? && @creator == current_user && @event.private?
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
