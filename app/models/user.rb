class User < ActiveRecord::Base

	validates :name, presence: true
	validates :email, presence: true, uniqueness: true

	has_many :events, :foreign_key => "creator_id", dependent: :destroy

	has_many :invites, :foreign_key => "attendee_id", dependent: :destroy
	has_many :attended_events, :through => :invites do
		def accepted
			where("invites.accepted = ?", true )
		end
		def declined
			where("invites.accepted = ?", false )
		end
		def pending
			where("invites.accepted IS NULL" )
		end
	end

	# is user invited to event?
	def invited?(event)
		attended_events.include?(event)
	end

	# is user attending the event (accepted invite)?
	def attending?(event)
		attended_events.accepted.include?(event)
	end

	# did user decline event invite?
	def declined?(event)
		attended_events.declined.include?(event)
	end

end