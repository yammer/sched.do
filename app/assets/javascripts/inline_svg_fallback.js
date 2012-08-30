$(document).ready(function(){
  if(Modernizr.svg) {
    var images = $('img[data-png-fallback]');
    images.each(function(i) {
      $(this).attr('src', $(this).data('png-fallback'));
    });
  }
});

