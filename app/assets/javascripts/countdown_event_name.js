$(document).ready(function(){
  var max = 70;
  var characters_remaining = max - $('#event_name').val().length;

  $('.text-counter').text(characters_remaining);

  $('#event_name').keyup(function () {

    characters_remaining = max - $(this).val().length;

    $('.text-counter').text(characters_remaining);

    if (parseInt(characters_remaining) < 0) {
      $('.char-limit').addClass('invalid-char-limit');
    }
    else {
      $('.char-limit').removeClass('invalid-char-limit');
    }
  });
});
