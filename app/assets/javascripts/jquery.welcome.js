var steps = $('section.steps li');

$(document).ready(function() {

  // Displays the first step
  $('.steps li:first-child').css('visibility', 'visible').addClass('animated');

  // Shows a step after the user scrolls past the previous one
  steps.waypoint(function(event, direction) {
      if (direction === 'down' && $(this).hasClass('first-step')) {
        $('a.learn-more-fixed').addClass('fade-out');
      }
      else if ($(this).hasClass('first-step')) {
        $('a.learn-more-fixed').removeClass('fade-out');
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
      $(this).addClass('fade-out');
      return false;
  });
});
