# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
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
