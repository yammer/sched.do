var welcomeHeader = $('#js-welcome-header');
var steps = $('section.steps li');

$(document).ready(function() {
  setMarginHeights();

  // Displays the first step when the user starts scrolling
  welcomeHeader.waypoint(function() {
    $('.steps li:first-child').css('visibility', 'visible');
  });

  // Shows a step after the user scrolls past the previous one
  steps.waypoint(function() {
    $(this).next('li').css('visibility', 'visible');
  }, {
    triggerOnce: 'true'
  });

});

$(window).resize(function() {
  setMarginHeights();
});

// Function that sets the top-margin and the height of the steps
var setMarginHeights = function() {

  var height = window.innerHeight;
  var welcomeHeader = $('#js-welcome-header');
  var headerMargin = (window.innerHeight - welcomeHeader.height()) / 2;

  if (height > 480) {
    welcomeHeader.css('margin-top', headerMargin);
  }

  steps.css({
    'height': headerMargin*0.6,
    'margin-top': headerMargin*0.2,
    'margin-bottom': headerMargin*0.2
  });

  $('section.steps li:last-child').css('margin-bottom', headerMargin);
};

