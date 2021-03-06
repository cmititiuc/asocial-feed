# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

setup = ->
  # set correct height for input field
  scrollHeight = $('#post_body').prop 'scrollHeight'
  $('#post_body').height scrollHeight
  $('#post_tag_list').select2({ tags: true })

$(document).ready setup
$(document).on 'page:load', setup

# enlarges input field as needed while typing
$(document).on 'keyup', '#post_body', ->
  scrollHeight = $(this).prop 'scrollHeight'
  padding = -(0 - $(this).css('padding-top').match(/[0-9]+/)[0] \
                - $(this).css('padding-bottom').match(/[0-9]+/)[0])
  $(this).height scrollHeight - padding

# shows/hides formatting reference
$(document).on 'click', '.formatting-help', ->
  $(this).children().toggle() # toggle link text
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

# switch edit link to cancel link
$(document).on 'ajax:success', '.edit', ->
  $(this).toggle()
  $(this).siblings('.cancel').css('display', 'inline-block')
  $(this).parent().siblings('.body').find('select:last').select2({ tags: true })

# replace original post text when canceling edit
$(document).on 'click', '.cancel', ->
  originalText = $(this).parent().siblings('.body').children('.original-text').html()
  $(this).parent().siblings('.body').html originalText
  # switch cancel link to edit link
  $(this).toggle()
  $(this).siblings('.edit').toggle()
  return false;

# add new post to page
$(document).on 'ajax:success', '#new_post', ->
  $('#new_post #post_body').val '' # clear text
  $('#new_post #post_body').height '' # reset height

  # removes the date from the second record if it is
  # the same as the date of the new record
  post = $('.post:first')
  newDate = post.children '.date'
  oldDate = post.next().children '.date'
  oldDate.text '' if newDate.text().trim() == oldDate.text().trim()

  # clear tag list field
  $('#post_tag_list').val(null).trigger 'change'

# delete a post
$(document).on 'ajax:success', '.destroy', (e, data)->
  post = $(this).closest '.grid'
  # set date for post after deleted one if it needs it
  deletedDate = post.children '.date'
  remainingDate = post.next().children '.date'
  if deletedDate.text().trim().length > 0 && remainingDate.text().trim().length == 0
    remainingDate.text deletedDate.text()
  # remove post
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
