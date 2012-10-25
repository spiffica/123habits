class UserObserver < ActiveRecord::Observer
	observe :user
	def after_update(model)
    # find all trackers of model
     if model.time_zone_changed?
    	model.trackers.update_users_trackers(model)
			model.logger.info(
				"\n\ntrackers have been updated for user: #{model.email}\n")
     end
	end
	def after_find(model)
		if model.last_visited.blank? || 
				model.last_visited.to_date != Time.zone.now.to_date
			unless model.trackers.blank?
				model.trackers.update_users_trackers(model)
				model.logger.info("\n\ntrackers have been updated\n")
				model.update_column(:last_visited, Time.now)
			end
		end
	end
end
