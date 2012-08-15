var steps = $('section.steps li');

$(document).ready(function() {

  // Displays the first step
  $('.steps li:first-child').css('visibility', 'visible').addClass('animated');

  // Shows a step after the user scrolls past the previous one
  steps.waypoint(function() {
    $(this).next('li').css('visibility', 'visible').addClass('animated');
  }, {
    triggerOnce: 'true',
    offset: '15%'
  });

  // Smooth scrolls from learn more link to steps
  $('a.learn-more').click(function(){
      $('html, body').animate({
          scrollTop: $( $(this).attr('href') ).offset().top
      }, 500);
      return false;
  });
});
