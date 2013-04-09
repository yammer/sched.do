$('.winner-button').on 'click', (event) ->
  event.preventDefault()

  data = $(event.currentTarget).data()
  form = $('.choose-winner form')
  message = form.find('#message')
  message.text(message.text().replace('_description_', data.description))

  form.find('#event_winning_suggestion_id').val(data.suggestionId)
  form.find('#event_winning_suggestion_type').val(data.suggestionType)

  $('.choose-winner').dialog('open')
