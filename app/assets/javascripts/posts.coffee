# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  # maintains input field height if page is reloaded while field contains text
  scrollHeight = $('#post_body').prop 'scrollHeight'
  $('#post_body').height scrollHeight

# enlarges input field as needed while typing
$(document).on 'keyup', '#post_body', ->
  scrollHeight = $(this).prop 'scrollHeight'
  $(this).height scrollHeight

# enlarges input field on turbolink (ie index > edit)
$(document).on 'page:load', ->
  scrollHeight = $('#post_body').prop 'scrollHeight'
  $('#post_body').height scrollHeight

# shows/hides formatting reference
$(document).on 'click', '#formatting-help', ->
  $('#markup-reference').toggle 400, ->
    match = $('#formatting-help').html().match /(H|h)ide.+/
    text = if match then 'Formatting help' else 'Hide formatting help'
    $('#formatting-help').html text
  return false;

# removes a notice when the X is clicked
$(document).on 'click', '.remove_notice', ->
  $(this).parent().remove()

# removes the date from the second record if it is
# the same as the date of the new record
$(document).on 'ajax:success', '#new_post', ->
  $('#new_post #post_body').val ''
  post = $('#filter-container').next()
  newDate = post.children '.date'
  oldDate = post.next().children '.date'
  oldDate.text '' if newDate.text().trim() == oldDate.text().trim()

window.getQueryVariable = (variable)->
   query = window.location.search.substring 1
   params = query.split "&"
   return param.split("=")[1] if param.split("=")[0] == variable for param in params
   return false