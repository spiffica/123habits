module TrackersHelper

	def get_class_list(tracker)
		class_list = "tracker"
		if tracker.success == true
			class_list += " true"
		elsif tracker.success == false
			class_list += " false"
		elsif tracker.day <= Time.zone.today
			class_list += " unfilled"
		else
			class_list += " future"
		end
	end

	def display_article(tracker)
		content_tag(:article, class: get_class_list(tracker)) do 
			yield if get_class_list(tracker) =~ /unfilled/

		end
	end



end
