class Invite < ActiveRecord::Base

	validates :attendee_id, presence: true
	validates :attended_event_id, presence: true

	belongs_to :attendee, :class_name => "User"
	belongs_to :attended_event, :class_name => "Event"

end
