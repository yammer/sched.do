if($("input[data-role='invitation_name']").length){
  $("input[data-role='invitation_name']").autocomplete({
    minLength: 1,
    appendTo: '.invitation-autocomplete-suggestions',
    open: function(event, ui){
          $('#auto-complete').addClass("autocomplete-true")
    },
    close: function(event, ui){
          $('#auto-complete').removeClass("autocomplete-true")
    },
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
  })
  .data( "autocomplete" )._renderItem = function( ul, item ) {
    return $( "<li></li>" )
      .data( "item.autocomplete", item )
      .append(
        "<a>" +
        "<div  class='autocomplete-avatar' style='background-image: url(" + item.photo + ")'></div>" +
        "<div class='profile'>" +
        "<p class='name'>" + item.label + "</p>" +
        "<p class='job-title'>" + item.jobTitle + "</p>" +
        "</div>" +
        "</a>"
      )
      .appendTo( ul );
  };
}

function clearAllNearbyDataRoles(target){
  fillInClosestFieldWithDataRole('', target, "yammer_user_id");
  fillInClosestFieldWithDataRole('', target, "yammer_group_id");
}

function fillInClosestFieldWithDataRole(id, target, dataRole){
  var dataRoleString = '[data-role="' + dataRole + '"]';
  var $field = $(target).closest('fieldset.inputs').find(dataRoleString);
  $field.prop('value', id);
}
