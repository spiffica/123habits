module TrackersHelper



	def display_article(tracker)
		content_tag(:article, class: "#{tracker.outcome} tracker") do 
			yield if block_given? && tracker == @habit.trackers.markable.first

		end
	end



end
