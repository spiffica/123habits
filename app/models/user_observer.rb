class UserObserver < ActiveRecord::Observer
	observe :user
	def after_update(user)
     if user.time_zone_changed?
				update_trackers_for(user)
     end
	end
	def after_find(user)
		if user.last_visited.blank? || 
				user.last_visited.to_date != Time.zone.now.to_date
			unless user.trackers.blank?
				update_trackers_for(user)
				user.update_column(:last_visited, Time.zone.now)
			end
		end
	end
	private
		def update_trackers_for(user)
			user.trackers.update_a_users_trackers(user)
			user.logger.info("\n\ntrackers have been updated for user: #{user.email}\n")
			user.logger.info("\n\nlast visited #{user.last_visited}\n 
				Time.now = #{Time.now}\nTznow = #{Time.zone.now}\n")
		end
end
