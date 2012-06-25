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

bind_to_new_time_fields();
bind_to_changed_primary_fields();

$('#new_event ol').bind("insertion-callback", function() {
  bind_to_new_time_fields();
  bind_to_changed_primary_fields();
});

function bind_to_new_time_fields() {
  $('.nested-fields.primary').bind("insertion-callback", function() {
    var primary_suggestions = $(this).find("[data-role='primary-suggestion']");
    var primary_suggestion_value = primary_suggestions.first().val();
    primary_suggestions.last().val(primary_suggestion_value);
  });
}

function bind_to_changed_primary_fields() {
  $("[data-role='primary-suggestion']").change(function() {
    var primary_suggestions = $(this).parents('.nested-fields.primary')
      .first().find("[data-role='primary-suggestion']");
    var primary_suggestion_value = primary_suggestions.first().val();
    primary_suggestions.each(function(index) {
      $(this).val(primary_suggestion_value);
    });
  });
}
