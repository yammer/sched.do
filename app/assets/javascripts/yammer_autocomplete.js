if($("input[data-role='invitation_name']").length){
  $.widget("custom.yammerAutocomplete", $.ui.autocomplete, {
    _renderMenu: function( ul, items ) {
      headers = {
        "user":"people",
        "group":"groups"
      }
      email = items.pop();
      var self = this;
      var currentType = "";
      $.each( items, function( index, item ) {
        if ( item.type != currentType ) {
          ul.append("<li class='ui-autocomplete-type'>" +
            "<div  class='category-icon "+
            headers[item.type] + "-icon'></div>" +
            "<span class='title'>" + headers[item.type] +
            "</span></li>");
          currentType = item.type;
        }
        self._renderItem( ul, item );
      });
      self._renderEmail( ul, email);
    },
    _renderEmail: function( ul, email ){
    return $("<li></li>")
      .data("item.autocomplete", email)
      .append(
        "<a class='email'>" +
        "<span>Email:</span>" + email.label +
        "</a>"
      )
      .appendTo(ul);

    },
    _renderItem: function(ul, item) {

    if (item.jobTitle) {
      var jobTitle = "<p class='job-title'>" + (item.jobTitle) + "</p>";
    } else {
      var jobTitle = "";
    };

    return $( "<li></li>" )
      .data("item.autocomplete", item)
      .append(
        "<a>" +
        "<div  class='autocomplete-avatar' style='background-image: url(" + item.photo + ")'></div>" +
        "<div class='outer-wrapper'><div class='profile'><div class='inner-wrapper'>" +
        "<p class='name'>" + item.label + "</p>" + jobTitle +
        "</div></div></div>" +
        "</a>"
      )
      .appendTo(ul);
  },
    options: {
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
        $(this).parents('form').submit();
      },
      source: function(request, response) {
        var term = request.term;
        YammerApi.setAccessToken(access_token);
        YammerApi.autocomplete.get(term, response);
      }
    }
  });

  if("access_token" in window){
    $("input[data-role='invitation_name']").yammerAutocomplete();
  }
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
