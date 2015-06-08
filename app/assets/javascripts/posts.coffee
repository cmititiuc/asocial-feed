# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  # Output viewport size (debug)
  $('body').prepend \
    'window width: ' + $(window).width() + '<br />' +
    'window height: ' + $(window).height() + '<br />' +
    ' screen width: ' + screen.width + '<br />screen height: ' + screen.height

  # Resize post form input field:
  
  # 1. GET
  scrollHeight = $('#post_body').prop 'scrollHeight'
  $('#post_body').height scrollHeight
  
  # 2. typing
  $(document).on 'keyup', '#post_body', ->
    scrollHeight = $(this).prop 'scrollHeight'
    $(this).height scrollHeight
  
  # 3. turbolink
  $(document).on 'page:load', ->
    scrollHeight = $('#post_body').prop 'scrollHeight'
    $('#post_body').height scrollHeight
