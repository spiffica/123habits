# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

# add the class to the parent table element to style the day according to 
# status of tracker update

$ ->
	$("article.overdue.tracker").closest("td.day").addClass "overdue"
	$("article.first_pending.tracker").closest("td.day").addClass "first_pending"
	$("article.fail.tracker").closest("td.day").addClass "fail"
	$("article.pass.tracker").closest("td.day").addClass "pass"
	$("article.pending.tracker").closest("td.day").addClass "pending"
	$("article.current.tracker").closest("td.day").addClass "current"

# submit the form as soon as the image is clicked
	$('form.edit_tracker').change ->
		$('form.edit_tracker').submit()
	
# can't seem to get this to work in popover
	pop_placement = (x) -> 
	  if $(x).closest("td").hasClass("wday-0")
	    place = "right"
	  else if $(x).closest("td").hasClass("wday-6")
	    place = "left"
	  else
	    place = "bottom"
	    options = {
	    	html: true,placement: 'right'} 
			options

# this does work; no need for it though
	# $('img.notes-icon').hover ->
	# 	$(this).toggleClass(pop_placement(this))	



	$('td.wday-0 img.notes-icon').popover({ 
											trigger: "hover",
											html: true,
											placement: 'right'
											})
	$('td.wday-6 img.notes-icon').popover( 
											trigger: "hover",
											html: true,
											placement: 'left'
											)
	$('img.notes-icon').popover( 
											trigger: "hover",
											html: true,
											placement: 'bottom'
											)
	