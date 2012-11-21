module TrackersHelper



	def display_article(tracker)
		content_tag(:article, class: "#{tracker.outcome} tracker") do 
			yield if block_given? 

		end
	end

	def display_tracker(tracker,tag)
		content_tag(tag, class: "#{tracker.outcome} tracker") do
			if tracker.first_markable?
				render 'trackers/form.html.erb', :tracker => tracker
				# content_tag(:p, "first markable!!")
			else
				content_tag(:p, class: tracker.outcome) do
					link_to(tracker.day.strftime('%A,%B %d'),"#none") 
				end
			end
		end
	end
end
