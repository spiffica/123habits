module TrackersHelper



	def display_article(tracker)
		content_tag(:article, class: "#{tracker.outcome} tracker") do 
			yield if block_given? 

		end
	end



end
