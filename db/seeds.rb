# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

users = [ User.create!(name:  "Ima Tester", email: "test@test.com"),
		User.create!(name:  "Foo Bar", email: "foo@bar.com"),
		User.create!(name:  "Jane Smith", email: "jsmith@example.com"),
		User.create!(name:  "John Doe", email: "doej@example.com"),
		User.create!(name:  "Demo User", email: "ex@example.com"),
		User.create!(name:  "Ben Marshall", email: "benmar@example.com"),
		User.create!(name:  "Sue Lasher", email: "slasher@example.com"),
		User.create!(name:  "Sharon	Lowe", email: "slowe@example.com"),
		User.create!(name:  "Linda Lee", email: "llee@example.com"),
		User.create!(name:  "Leroy Jenkins", email: "lbj@example.com") ]

count_range = (0..6).to_a

def time_rand from = 0.0, to = Time.now
  Time.at(from + rand * (to.to_f - from.to_f))
end

event_prefix =  [ "", "", "", "", "", "", "", "", "", "", "", "", "", "",
				 "My ", "Someone's ", "Another ", "Awesome ", "Uptown ",
				"Cool ", "Extreme ", "Generic ", "Open ", "Local ",
				"Fancy ", "Casual ", "Downtown ", "Upscale ", "Super " ]
event = [ "Birthday Party", "Game Night", "Movie Night", "Lightswitch Rave", 
		"Book Club", "Dance Lesson", "Dinner Party", "Concert", 
		"Art Show", "Secret Meeting", "Dance Party", "Cooking Lesson",
		"Hackathon", "Talent Show", "D&D Session", "Potluck",
		"Wine Tasting", "Writeathon", "Poetry Slam", "Charity Ball" ]

lorem = [ "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec sed orci justo. Quisque cursus, enim ac finibus dapibus, justo mauris posuere urna, at efficitur justo dui in ligula. Aliquam erat volutpat. Nullam arcu sapien, fringilla sit amet pharetra ac, rhoncus sed magna. Nam quis sapien viverra, rutrum nisi nec, gravida augue. Curabitur lacinia posuere malesuada.",
	"Duis eget lacus dui. Morbi vitae purus orci. Mauris quis dui at orci efficitur pulvinar quis ac est. Suspendisse non mi viverra, mollis justo sed, elementum nulla.",
"Quisque at laoreet tellus. Donec libero eros, tempus suscipit lacus in, malesuada pretium ante. In et tempus felis, in elementum nisl. Sed tincidunt felis in aliquam rhoncus. Phasellus a pulvinar nisl. Sed ac consequat quam, eu luctus dui. Sed vehicula sagittis risus vel venenatis.",
"Donec elementum mi sed ultrices suscipit. Phasellus at tempus tellus. Curabitur et luctus turpis. Aliquam mollis velit vel urna dapibus bibendum. Vestibulum vitae sapien eget arcu euismod venenatis. Aenean in dui sit amet orci congue porta. Etiam ut arcu eu felis fermentum semper. Donec blandit auctor augue, sed porttitor risus laoreet vitae. Pellentesque in ante efficitur, semper lorem nec, varius libero.",
"Phasellus eget tellus scelerisque, condimentum turpis in, cursus arcu. Sed eget venenatis turpis, at convallis nunc.",
"Nulla tempor ante a commodo pulvinar. Sed sed bibendum dolor, et pretium elit. Duis nisi nibh, bibendum sit amet justo in, laoreet sollicitudin erat. Aenean non sem dui. Etiam sit amet sollicitudin justo. Ut sodales eros eros, id suscipit dui cursus ut. Pellentesque a vestibulum mi, ut varius arcu. Ut eros nisi, ultricies vel augue et, convallis eleifend nibh.",
"Nullam at ornare leo, sit amet elementum lorem. Nulla massa tellus, porttitor nec accumsan non, vestibulum non lorem. Suspendisse placerat mi at metus eleifend eleifend."
]

location = [ "", "", "", "123 Main Street", "Uptown", "Downtown", "Midtown", 
	"Anytown, USA", "My House", "The Brew Pub", "1313 Dead End Dr.", "Room 1408",
	"Town Hall", "987 Broadway", "Convention Center", "The Red Room", "Tea House", 
	"My Basement", "The Park", "546 Penny Lane", "Our Backyard", "", "", "" ]

events = []

users.each do |user|
	n = count_range[1..3].sample
	n.times do
		title = event_prefix.sample + event.sample
		date = time_rand(Time.local(2015, 1, 1), Time.local(2017, 12, 31))
		title = title+"!" if (date.year+date.month+date.day)%3 == 0
		events << user.events.create!( title: title, date: date, description: lorem.sample, location: location.sample )
	end
end

events.each do |event|
	n = count_range.sample
	user_subset = n%2 == 0 ? users[0..n] : users[n..-1]
	user_subset.each do |user|
		event.invites.create!(attendee_id: user.id)
	end
end