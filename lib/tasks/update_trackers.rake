desc "Get all users whose local time is Midnight and update all unmarked \n
trackers outcomes' "
task :midnight_update_trackers => :environment do
	msg = "Users affected: "
	h_msg = "Habits affected: "
	a = User.midnight.map do |u|
		tz = u.time_zone
		msg << "#{u.name}, "
		u.habits.map do |h|
			h_msg << "#{h.id}, "

			h.trackers.update_unmarked_trackers(tz)
		end
	end
	puts msg
	puts h_msg
	p a 
end

desc "Update all Trackers to User timezone"
task :update_trackers => :environment do
	User.all.each do |u|
		tz = u.time_zone
		u.habits.each do |h|
			h.trackers.update_unmarked_trackers(tz)
		end
	end
end
