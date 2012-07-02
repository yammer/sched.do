var welcomeHeader = $('#js-welcome-header');
var steps = $('section.steps li');

$(document).ready(function() {
  // setMarginHeights();

  // Displays the first step when the user starts scrolling
  welcomeHeader.waypoint(function() {
    $('.steps li:first-child').css('visibility', 'visible');
  });

  // Shows a step after the user scrolls past the previous one
  steps.waypoint(function() {
    // $(this).next('li').css('visibility', 'visible').addClass('animated');
    $(this).next('li').css('visibility', 'visible');
  }, {
    triggerOnce: 'true'
  });

});

$(window).resize(function() {
  // setMarginHeights();
});

// Function that sets the top-margin and the height of the steps
var setMarginHeights = function() {

  var viewportHeight = window.innerHeight;
  var viewportWidth = window.innerWidth;
  var headerHeight = viewportHeight * 0.65;

  if (viewportWidth > 480) {
    welcomeHeader.css('height', headerHeight);
  }
};

