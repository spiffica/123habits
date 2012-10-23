module UserTime


	def is_hour?(any_hour)
		Time.now.in_time_zone(self.time_zone).hour == any_hour
	end

	def is_midnight?
		self.is_hour? 0
	end

	def user_utc_offset
		Time.now.in_time_zone(self.time_zone).utc_offset / 3600
	end

	def current_hour
		Time.now.in_time_zone(self.time_zone).hour
	end
end