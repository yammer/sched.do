$('.winner-button').on 'click', (event) ->
  event.preventDefault()

  data = $(event.currentTarget).data()
  form = $('.choose-winner form')
  messageEl = form.find('.customize-message')
  messageEl.text("I've chosen #{data.description} for #{data.eventName}.")
  $('.choose-winner h2').text(data.description)

  form.find('#winning_suggestion_id').val(data.suggestionId)
  form.find('#winning_suggestion_type').val(data.suggestionType)

  $('.choose-winner').dialog('open')
