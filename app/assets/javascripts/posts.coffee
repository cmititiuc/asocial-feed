# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

setup = ->
  # set correct height for input field
  scrollHeight = $('#post_body').prop 'scrollHeight'
  $('#post_body').height scrollHeight

$(document).ready setup
$(document).on 'page:load', setup

# enlarges input field as needed while typing
$(document).on 'keyup', '#post_body', ->
  scrollHeight = $(this).prop 'scrollHeight'
  $(this).height scrollHeight

# shows/hides formatting reference
$(document).on 'click', '.formatting-help', ->
  $(this).children().toggle() # toggle link text
  # $('#markup-reference').toggle 400
  form = $(this).closest 'form'
  markup = $(this).closest('form').siblings '.markup-reference'
  unless markup.length
    form.after '<div class="markup-reference">' + $('.markup-reference:first').html() + '</div>'
  $(this).closest('form').siblings('.markup-reference').toggle 400
  return false;

# removes a notice when the X is clicked
$(document).on 'click', '.remove_notice', ->
  $(this).parent().remove()

# don't get the form if it's already present
$(document).on 'ajax:beforeSend', '.edit', ->
  if $(this).parent().siblings('.body').children('form').length
    return false;

# replace original post text when canceling edit
$(document).on 'click', '.cancel', ->
  originalText = $(this).closest('.body').children('.original-text').html()
  $(this).closest('.body').html originalText
  return false;

# add new post to page
$(document).on 'ajax:success', '#new_post', ->
  $('#new_post #post_body').val '' # clear text
  $('#new_post #post_body').height '' # reset height
  
  # clear topic_id selector if no filter is set
  $('#post_topic_id').val '' unless getQueryVariable 'topic_id'

  # removes the date from the second record if it is
  # the same as the date of the new record
  post = $('#filter-container').next()
  newDate = post.children '.date'
  oldDate = post.next().children '.date'
  oldDate.text '' if newDate.text().trim() == oldDate.text().trim()

# if edit succeeds, update the view
$(document).on 'ajax:success', '.edit_post', ->
  $.ajax {
      url: '/posts/' + $(this).prop('id').match(/[0-9]+/)[0],
      dataType: "json"
    }
    .done (result) =>
      topic = $(this).parent().siblings '.topic'
      topic.html if result.topic then result.topic.name else ''
      $(this).html result.body

# delete a post
$(document).on 'ajax:success', '.destroy', (e, data)->
  # print notice
  $('#notices').append '<div class="notice">' + data + '<div class="remove_notice">X</div></div>'
  $('.notice').last().delay(2500).fadeOut 'slow', -> $(this).remove()
  post = $(this).closest '.grid'
  # set date for post after deleted one if it needs it
  deletedDate = post.children '.date'
  remainingDate = post.next().children '.date'
  if deletedDate.text().trim().length > 0 && remainingDate.text().trim().length == 0
    remainingDate.text deletedDate.text()
  post.animate {
    opacity:        0,
    height:        '0',
    paddingTop:    '0',
    paddingBottom: '0',
    marginTop:     '0',
    marginBottom:  '0'
  }, 400, -> post.remove()

# returns param value of variable or null
window.getQueryVariable = (variable)->
   query = window.location.search.substring 1
   params = query.split "&"
   return param.split("=")[1] if param.split("=")[0] == variable for param in params
   return false
