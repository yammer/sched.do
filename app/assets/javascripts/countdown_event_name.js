$(document).ready(function(){
  var max = 70
  var characters_remaining = max

  $('.text-counter').text(characters_remaining);

  $('#event_name').keyup(function () {

    characters_remaining = max - $(this).val().length;

    $('.text-counter').text(characters_remaining);
  });

  $('#event_name').keyup();

});
