$(document).ready(function(){
  var left = 28
  $('.text-counter').text(left);

  $('#event_name').keyup(function () {

    left = 28 - $(this).val().length;

    if(left < 0){
      $('.text-counter').addClass("overlimit");
    }

    if(left >= 0){
      $('.text-counter').removeClass("overlimit");
    }

    $('.text-counter').text(left);
  });
});
