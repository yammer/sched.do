// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require cocoon
//= require underscore
//= require_tree .
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
