class Invite < ActiveRecord::Base

	scope :accepted, -> { where(accepted: true) }
	scope :declined, -> { where(accepted: false) }
	scope :pending, -> { where(accepted: nil) }

	validates :attendee_id, presence: true
	validates :attended_event_id, presence: true

	belongs_to :attendee, :class_name => "User"
	belongs_to :attended_event, :class_name => "Event"


	# who created the invite? Attentee on public events, event creator on private events.
	def author
		attended_event.private? ? attended_event.creator : attendee
	end

end
