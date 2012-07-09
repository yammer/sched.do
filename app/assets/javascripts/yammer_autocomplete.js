$("input[data-role='invitation_name']").autocomplete({
  minLength: 3,
  appendTo: '.invitation-autocomplete-suggestions',
  select: function(event, ui) {
    var target = event.target;
    var yammerUserId = ui.item.yammerUserId;
    var $yammerUserIdField = $(target).closest('fieldset.inputs').find('[data-role="yammer_user_id"]');
    $yammerUserIdField.prop('value', yammerUserId);
  },
  source: function(request, response) {
    var term = request.term;
    YammerApi.setAccessToken(access_token);
    YammerApi.autocomplete.get(term, response);
  }
});
