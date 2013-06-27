Namespaced.declare('Scheddo')

$('.votable').delegate '.vote[data-role=create]', 'ajax:success', (e, data, textStatus, jqXHR) ->
  Scheddo.newVoteCallback.call(this, data)

$('.votable').delegate '.vote[data-role=update]', 'ajax:success', (e, data, textStatus, jqXHR) ->
  Scheddo.changeVoteCallback.call(this, data)

$('.votable').delegate '.vote', 'ajax:error', (e, data, textStatus, jqXHR) ->
  Scheddo.voteErrorCallback.call(this, data)

$('.votable').delegate '.vote', 'ajax:beforeSend', (e, data, textStatus, jqXHR) ->
  if $('body').hasClass('loading')
    return false
  $('body').addClass('loading')

$('.votable').on 'click', (e, data, status, jqXhr) ->

Scheddo.newVoteCallback = (data) ->
  $('body').removeClass('loading')
  $(this).attr('data-role','update')
  $(this).attr('action',"/votes/#{data.vote.id}")
  $(this).find('#vote_id').val(data.vote.id)
  $(this).append($('<input name=_method type=hidden value=put />'))
  $(this).find('input.vote').attr('value', 'Unvote')
  $(this).find('input.vote').removeClass('vote').addClass('unvote')
  id = $(this).parent().data('id')
  newVoteCount = parseInt($(".vote-count[data-id=#{id}]").text(), 10) + 1
  $(".vote-count[data-id=#{id}]").html("<span>#{newVoteCount}</span>")

Scheddo.changeVoteCallback = (data) ->
  $('body').removeClass('loading')
  action = $(this).find('#vote_submit_action').children().attr('value')
  id = $(this).parent().data('id')

  if(action == 'Unvote')
    newVoteCount = parseInt($(".vote-count[data-id=#{id}]").text(), 10) - 1
    $(".vote-count[data-id=#{id}]").html("<span>#{newVoteCount}</span>")
    $(this).find('input.unvote').attr('value', 'Vote')
    $(this).find('input.unvote').removeClass('unvote').addClass('vote')
  else if(action == 'Vote')
    newVoteCount = parseInt($(".vote-count[data-id=#{id}]").text(), 10) + 1
    $(".vote-count[data-id=#{id}]").html("<span>#{newVoteCount}</span>")
    $(this).find('input.vote').attr('value', 'Unvote')
    $(this).find('input.vote').removeClass('vote').addClass('unvote')

Scheddo.voteErrorCallback = (data) ->
  $('body').removeClass('loading')
  $(".flash").append($("<div id=flash-error>#{data.statusText}</div>"))

$(".vote").hover (->
  $(this).data 'hover', true
), ->
  $(this).data 'hover', false


