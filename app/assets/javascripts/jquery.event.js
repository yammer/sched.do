$(document).ready(function() {
  var table = $('table.touch-scrollable');
  var parent = $('table.touch-scrollable').parent();
  var scrollNotice = $('div.scroll-notice')

  var getCurrentOffset = function() {
    var totalOffset = table.width() - parent.innerWidth();
    var currentOffset = (totalOffset - parent.scrollLeft())

    return { total: totalOffset, current: currentOffset };
  }

  var setLabel = function() {
    var offsets = getCurrentOffset()

    if (offsets.total > 0) {

      if (offsets.current === 0) {
        scrollNotice.removeClass('visible');
      } else {
        scrollNotice.addClass('visible');
      }
    }
  };

  setLabel();

  scrollNotice.click(function() {
    var offsets = getCurrentOffset()

    parent.animate({ scrollLeft: offsets.current }, 300);
  });

  parent.scroll(function() {
    setLabel();
  });

  $(window).resize(function() {
    setLabel();
  });
});
