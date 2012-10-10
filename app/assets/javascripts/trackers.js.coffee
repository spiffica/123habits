# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
#$('article.tracker').first().css 'background-color', 'green'
$ ->
	$("article.unfilled.tracker").closest("td.day").addClass "unfilled"
	$("article.false.tracker").closest("td.day").addClass "false"
	$("article.true.tracker").closest("td.day").addClass "true"
	$("article.future.tracker").closest("td.day").addClass "future_tracker"

	$('form.edit_tracker').change ->
		$('form.edit_tracker').submit()

	# $('input#tracker_success_true + label').html('')