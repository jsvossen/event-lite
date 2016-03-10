class Event < ActiveRecord::Base

	scope :upcoming, -> { where("date >= ?", Time.now).order(date: :asc) }
	scope :past, -> { where("date < ?", Time.now).order(date: :desc) }

	validates :title, presence: true
	validates :date, presence: true
	validates :creator_id, presence: true

	belongs_to :creator, :class_name => "User"
	
	has_many :invites, :foreign_key => "attended_event_id", dependent: :destroy
	has_many :attendees, :through => :invites

	def formatted_date
		date.strftime("%b %d, %Y at %I:%M%p")
	end

end
