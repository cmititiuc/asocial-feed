# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  scrollHeight = $('#post_body').prop 'scrollHeight'
  $('#post_body').height scrollHeight
  
$(document).on 'keyup', '#post_body', ->
  scrollHeight = $(this).prop 'scrollHeight'
  $(this).height scrollHeight

$(document).on 'page:load', ->
  scrollHeight = $('#post_body').prop 'scrollHeight'
  $('#post_body').height scrollHeight

$(document).on 'click', '#formatting-help', ->
  $('#markup-reference').toggle 400, ->
    match = $('#formatting-help').html().match /(H|h)ide.+/
    text = if match then 'Formatting help' else 'Hide formatting help'
    $('#formatting-help').html text
  return false;