var steps = $('section.steps li');

$(document).ready(function() {

  // Displays the first step
  $('.steps li:first-child').css('visibility', 'visible').addClass('animated');

  // Shows a step after the user scrolls past the previous one
  steps.waypoint(function(event, direction) {
      if (direction === 'down' && $(this).hasClass('first-step')) {
        $('div.learn-more-wrapper').removeClass('fixed');
      }
      else if ($(this).hasClass('first-step')) {
        $('div.learn-more-wrapper').addClass('fixed');
      }

    $(this).css('visibility', 'visible').addClass('animated');
  }, {
    offset: '100%'
  });

  // Smooth scrolls from learn more link to steps
  $('a.learn-more-fixed').click(function(){
      $('html, body').animate({
          scrollTop: $( $(this).attr('href') ).offset().top
      }, 500);
      $('div.learn-more-wrapper').removeClass('fixed');
      return false;
  });

  $('a.learn-more-postit').click(function(){
      $('html, body').animate({
          scrollTop: $( $(this).attr('href') ).offset().top
      }, 500);
      return false;
  });

  window.require_tos_acceptance = function(e){
     if(!$('input[name=agree_to_tos][type=checkbox]').is(':checked')){
      e.preventDefault();
      $(window).scrollTop(0);
      var termsOfServicePrompt = '<div id=flash-error>Please agree to the terms of service</div>';
      $('.flash').html(termsOfServicePrompt);
      $('#flash-error').delay(3000).fadeTo(300, 0);
      $('input[name=agree_to_tos][type=checkbox]').prop('checked', true);
     }
  }

  $('input.sign-in').click(require_tos_acceptance);
});
