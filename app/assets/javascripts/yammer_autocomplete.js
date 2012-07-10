$("input[data-role='invitation_name']").autocomplete({
  minLength: 3,
  appendTo: '.invitation-autocomplete-suggestions',
  select: function(event, ui) {
    var id;
    var dataRole;
    clearAllNearbyDataRoles(event.target);
    if (ui.item.yammerUserId) {
      id = ui.item.yammerUserId;
      dataRole = "yammer_user_id";
    }
    else{
      id = ui.item.yammerGroupId;
      dataRole = "yammer_group_id";
    };
    fillInClosestFieldWithDataRole(id, event.target, dataRole);
  },
  source: function(request, response) {
    var term = request.term;
    YammerApi.setAccessToken(access_token);
    YammerApi.autocomplete.get(term, response);
  }
});

function clearAllNearbyDataRoles(target){
  fillInClosestFieldWithDataRole('', target, "yammer_user_id");
  fillInClosestFieldWithDataRole('', target, "yammer_group_id");
}

function fillInClosestFieldWithDataRole(id, target, dataRole){
  var dataRoleString = '[data-role="' + dataRole + '"]';
  var $field = $(target).closest('fieldset.inputs').find(dataRoleString);
  $field.prop('value', id);
}
