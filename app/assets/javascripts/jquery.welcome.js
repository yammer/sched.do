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
});
