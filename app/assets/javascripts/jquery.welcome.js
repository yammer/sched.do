var welcomeHeader = $('#js-welcome-header');

$(document).ready(function() {
  if (window.innerHeight > 480) {
    setTopMargin();
  }

  var headerPosition = welcomeHeader.offset().top;
  $('#learn-more').click(function(){
    $('html, body').animate({scrollTop:headerPosition}, 'slow');
    welcomeHeader.css('margin-bottom', '300px');
    return false;
  });
});

$(window).resize(function() {
    if (window.innerHeight > 480) {
      setTopMargin();
    }
});

var setTopMargin = function() {
  var steps = $('section.steps');
  var headerMargins = (window.innerHeight - welcomeHeader.height()) / 2;

  welcomeHeader.css({
    'margin-top': headerMargins,
    'margin-bottom': headerMargins
  });

  steps.css('margin-bottom', headerMargins);
};
