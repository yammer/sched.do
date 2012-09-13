$(".votable").delegate ".vote[data-role=create]", "ajax:success", (e, data, textStatus, jqXHR) ->
  voteCallback.call(this, data)
$(".votable").delegate ".vote[data-role=delete]", "ajax:success", (e, data, textStatus, jqXHR) ->
  unvoteCallback.call(this, data)
$(".votable").delegate ".vote", "ajax:error", (e, data, textStatus, jqXHR) ->
  voteErrorCallback.call(this, data)
$(".votable").delegate ".vote", "ajax:beforeSend", (e, data, textStatus, jqXHR) ->
  if $('body').hasClass('loading')
    return false
  $('body').addClass('loading')


window.voteCallback = (data) ->
  $('body').removeClass('loading')
  $(this).attr('data-role','delete')
  $(this).attr('action',"/votes/#{data.vote.id}")
  $(this).append($('<input name="_method" type="hidden" value="delete" />'))
  $(this).one 'mouseout', ->
    $(this).find('input.vote').removeClass("vote").addClass("unvote")
  id = $(this).parent().data('id')
  $(".vote-count[data-id=#{id}]").text(parseInt($(".vote-count[data-id=#{id}]").text()) + 1 )


window.unvoteCallback = (data) ->
  $('body').removeClass('loading')
  $(this).attr('data-role','create')
  $(this).attr('action',"/votes")
  $(this).find('input[value=delete]').remove()
  $(this).one 'mouseout', ->
    $(this).find('input.unvote').removeClass("unvote").addClass("vote")
  id = $(this).parent().data('id')
  $(".vote-count[data-id=#{id}]").text(parseInt($(".vote-count[data-id=#{id}]").text()) - 1 )

window.voteErrorCallback = (data) ->
  $('body').removeClass('loading')
  $(".flash").append($("<div id=flash-error>#{data.statusText}</div>"))


