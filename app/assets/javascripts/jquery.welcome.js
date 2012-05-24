var welcomeHeader = $('#js-welcome-header');

$(document).ready(function() {
   setMarginHeights();
});

$(window).resize(function() {
   setMarginHeights();
});

// Function that sets the top-margin and the height of the steps
var setMarginHeights = function() {

  var steps = $('section.steps li');
  var height = window.innerHeight;
  var welcomeHeader = $('#js-welcome-header');
  var headerMargin = (window.innerHeight - welcomeHeader.height()) / 2;

  if (height > 480) {
    welcomeHeader.css('margin-top', headerMargin);
  }

  steps.css('height', headerMargin*0.6);
};
