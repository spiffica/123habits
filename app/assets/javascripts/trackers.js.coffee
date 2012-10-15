# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

# add the class to the parent table element to style the day according to 
# status of tracker update

$ ->
	$("article.pending.tracker").closest("td.day").addClass "pending"
	$("article.first_pending.tracker").closest("td.day").addClass "first_pending"
	$("article.false.tracker").closest("td.day").addClass "false"
	$("article.true.tracker").closest("td.day").addClass "true"
	$("article.future.tracker").closest("td.day").addClass "future_tracker"

# submit the form as soon as the image is clicked
	$('form.edit_tracker').change ->
		$('form.edit_tracker').submit()

