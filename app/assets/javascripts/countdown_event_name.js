$(document).ready(function(){
  var max = 70
  var characters_remaining = max

  $('.text-counter').text(characters_remaining);

  $('#event_name').keyup(function () {

    characters_remaining = max - $(this).val().length;

    if(characters_remaining < 0){
      $('.text-counter').addClass("overlimit");
    }

    if(characters_remaining >= 0){
      $('.text-counter').removeClass("overlimit");
    }

    $('.text-counter').text(characters_remaining);
  });
});
