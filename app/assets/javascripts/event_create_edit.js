//= require countdown_event_name
//= require events
//= require jquery.app
//= require jquery-placeholder

$(document).ready(function(){
  $('#new_event').submit(function(){
    $('.cta').prop('disabled', true);
  });
});
