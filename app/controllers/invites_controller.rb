class InvitesController < ApplicationController

	before_action :logged_in_user, only: [:create, :destroy, :index, :update]
	before_action :correct_user, only: :update
	before_action :user_is_author, only: :destroy

	def create
		@invite = Invite.new(invite_params)
		# find attendee via email if present
		if params[:guest_email] 
			user = User.find_by_email(params[:guest_email])
			if user
				if user.invited?(@invite.attended_event)
					flash[:danger] = "#{user.name} (#{user.email}) is already invited."
					redirect_to @invite.attended_event and return
				else
					@invite.attendee = user
				end
			else
				flash[:danger] = "User #{params[:guest_email]} not found."
				redirect_to @invite.attended_event and return
			end
		end
		# save invite
		if @invite.save
			flash[:success] = params[:guest_email] ? "Invitation sent to #{@invite.attendee.name} (#{@invite.attendee.email})." :
				"You are attending #{@invite.attended_event.title}"
			redirect_to @invite.attended_event
		else
			errors = @invite.errors.full_messages.join(". ")
			flash[:danger] = "RSVP error: #{errors}"
			redirect_to @invite.attended_event
		end
	end 

	def update
		@invite = Invite.find(params[:id])
		if @invite.update_attributes(invite_params)
			if @invite.accepted?
				flash[:success] = "You are attending #{@invite.attended_event.title}"
			else
				flash[:success] = "You decline to attend #{@invite.attended_event.title}"
			end
			redirect_to @invite.attended_event
		else
			errors = @invite.errors.full_messages.join(". ")
			flash[:danger] = "RSVP error #{errors}"
			redirect_to @invite.attended_event
		end
	end

	def destroy
		@invite = Invite.find(params[:id])
		event = @invite.attended_event
		@invite.destroy
		flash[:success] = "You are no longer attending #{event.title}"
		redirect_to event
	end

	def index
		@pending_events = current_user.attended_events.pending.upcoming
		@accepted_events = current_user.attended_events.accepted.upcoming
		@declined_events = current_user.attended_events.declined.upcoming
	end


	private

		def invite_params
			params.require(:invite).permit(:attendee_id, :attended_event_id, :accepted)
		end

		# the attendee can only edit their own invite
		def correct_user
		    @user = Invite.find(params[:id]).attendee
		    redirect_to current_user unless  @user == current_user
    	end

    	# on open events, the attendee can only delete their own invites,
    	# on private events, the event creator can only delete invites they've made
    	def user_is_author
    		@user = Invite.find(params[:id]).author
    		redirect_to current_user unless  @user == current_user
    	end

end
