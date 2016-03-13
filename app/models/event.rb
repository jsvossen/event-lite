class Event < ActiveRecord::Base

	scope :upcoming, -> { where("date >= ?", Time.now).order(date: :asc) }
	scope :past, -> { where("date < ?", Time.now).order(date: :desc) }
	scope :closed, -> { where(private: true) }
	scope :open, -> { where(private: false) }

	validates :title, presence: true
	validates :date, presence: true
	validates :creator_id, presence: true

	belongs_to :creator, :class_name => "User"
	
	has_many :invites, :foreign_key => "attended_event_id", dependent: :destroy
	has_many :attendees, :through => :invites do
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

	def formatted_date
		date.strftime("%b %d, %Y at %I:%M%p")
	end

end
