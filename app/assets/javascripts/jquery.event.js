$(document).ready(function() {
  if (!swfobject.hasFlashPlayerVersion("9.0.18")) {
    $(".alt-invite").hide();
    $("#invitations").css("margin-right", 0)
  }
  var table = $('table.touch-scrollable');
  var parent = $('table.touch-scrollable').parent();

  // Scroll Notice
  var scrollNotice = $('div.scroll-notice')
  var scrollRight = $('div.scroll-notice.forward')
  var scrollLeft = $('div.scroll-notice.backward')

  var getCurrentOffset = function() {
    var totalOffset = table.width() - parent.innerWidth();
    var currentOffset = (totalOffset - parent.scrollLeft())

    return { total: totalOffset, current: currentOffset };
  }

  var setLabel = function() {
    var offsets = getCurrentOffset()

    if (offsets.total > 0) {
      scrollNotice.addClass('visible');
      if (offsets.current === 0) {
        scrollRight.removeClass('visible');
      } else if (offsets.current === offsets.total) {
        scrollLeft.removeClass('visible');
      }
    }
  };

  setLabel();

  scrollNotice.click(function() {
    var offsets = getCurrentOffset();
    var isForward = $(this).is('.forward');
    var distanceToScroll = isForward ? offsets.total : 0;

    parent.animate({ scrollLeft: distanceToScroll }, 300);
  });

  parent.scroll(function() {
    setLabel();
  });

  $(window).resize(function() {
    setLabel();
  });

  // Editable Event Name
  $('.event-name.editable h1').click(function(){
    $(this).hide();
    $('.event-name input').show().focus();
  });

  $('.event-name.editable input').blur(function(){
    $.ajax(
      {
        type: 'PUT',
        dataType:'json',
        url: document.URL,
        data: { event: { name: $(this).val() } },
      }
      ).success(function(){
          $('.event-name h1').text($('.event-name input').val());
          $('.event-name input').hide();
          $('.event-name h1').show();
        }
        );

  })
});
