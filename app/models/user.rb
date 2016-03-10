class User < ActiveRecord::Base

	validates :name, presence: true
	validates :email, presence: true, uniqueness: true

	has_many :events, :foreign_key => "creator_id", dependent: :destroy

	has_many :invites, :foreign_key => "attendee_id", dependent: :destroy
	has_many :attended_events, :through => :invites

	def attending?(event)
		attended_events.include?(event)
	end

end
