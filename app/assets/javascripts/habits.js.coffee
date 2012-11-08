# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $('#habits_menu a.local').on 'click', (e) ->
    e.preventDefault()
    $(this).tab "show"

  $('button[data-dismiss="modal"]').on 'click', ->
    $('div.modal').hide()  