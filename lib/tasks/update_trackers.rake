desc "Get all users whose local time is Midnight and update all unmarked \n
trackers outcomes' "
task :midnight_update_trackers => :environment do
	# msg = "Users affected: "
	# User.midnight.map do |u|
	# 	msg << "#{u.name}, "
	# 	u.trackers.update_unmarked_trackers(u.time_zone)
	# end
	# puts msg
	# puts "#{Time.now.utc} in Grenwich"
	# puts "#{Time.zone.now} on server"
	# puts "#{Time.now.in_time_zone(tz)} in #{tz}" if defined? tz
end

desc "Update all Trackers to User timezone"
task :update_trackers => :environment do
	User.all.map do |u|
		u.trackers.update_unmarked_trackers(u.time_zone)
	end
end
