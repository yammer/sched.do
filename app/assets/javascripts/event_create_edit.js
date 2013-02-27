//= require countdown_event_name
//= require events
//= require event_form
//= require jquery-placeholder

$(document).ready(function(){
  $('#new_event').submit(function(){
    $('.cta').prop('disabled', true);
  });
});
