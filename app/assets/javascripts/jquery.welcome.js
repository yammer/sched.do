var scrollCallout = $('div.learn-more');
var steps = $('section.steps li');

$(document).ready(function() {

  // Displays the first step when the user starts scrolling
  scrollCallout.waypoint(function() {
    $('.steps li:first-child').css('visibility', 'visible').addClass('animated');
    scrollCallout.slideUp('fast');
  }, {
   offset: '51%'
  });

  // Shows a step after the user scrolls past the previous one
  steps.waypoint(function() {
    $(this).next('li').css('visibility', 'visible').addClass('animated');
  }, {
    triggerOnce: 'true'
  });

});
