$(document).ready(function() {
  if (!swfobject.hasFlashPlayerVersion('9.0.18')) {
    $('button#copy-event-url').parent().remove();
    $('ul.poll-actions a.edit-button').addClass('single');
  }

  var table = $('table.touch-scrollable');
  var parent = $('table.touch-scrollable').parent();

  var isMicrosoftSurface = 'onmsgesturechange' in window;
  var isTouch = Modernizr.touch || isMicrosoftSurface;

  if (isTouch) {
    table.addClass('scrollable horizontal');
    parent.addClass('touch-scrollable');
  }

  // Scroll Notice
  var scrollNotice = $('div.scroll-notice');
  var scrollRight = $('div.scroll-notice.forward');
  var scrollLeft = $('div.scroll-notice.backward');
  var numberOfOptions = table.find('thead tr th').size();
  var borderWidth = 2;
  var oneStepOffset = table.width() / numberOfOptions + borderWidth;

  var getCurrentOffset = function() {
    var totalOffset = table.width() - parent.innerWidth();
    var currentOffset = (totalOffset - parent.scrollLeft());

    return { total: totalOffset, current: currentOffset };
  }

  var setLabel = function() {
    var offsets = getCurrentOffset();

    if (offsets.total > 0 && !isTouch) {
      scrollNotice.addClass('visible');
      if (offsets.current === 0) {
        scrollRight.removeClass('visible');
      } else if (offsets.current === offsets.total) {
        scrollLeft.removeClass('visible');
      }
    }
  };

  setLabel();

  parent.scroll(function() {
    setLabel();
  });

  $(window).resize(function() {
    setLabel();
  });

  // Click handler
  var pressTimer

  scrollNotice.mouseup(function(){
    clearTimeout(pressTimer)
    return false;
  }).mousedown(function(){
    var isForward = $(this).is('.forward');
    var offsets = getCurrentOffset();
    var totalDistanceToScroll = isForward ? offsets.total : 0;
    var distanceToScroll = isForward ? parent.scrollLeft() + oneStepOffset : parent.scrollLeft() - oneStepOffset;

    parent.animate({ scrollLeft: distanceToScroll }, 300);
    pressTimer = window.setTimeout(function() {
      parent.animate({ scrollLeft: totalDistanceToScroll }, 300);
    },500)
    return false;
  });

  $('.custom-text').tooltip();

  $('ul.poll-actions li').tooltip();

  $('#copy-event-url').zclip({
    copy: $('#copy-event-url').data('event-url'),
    afterCopy: function() {
      var parent = $('#copy-event-url').parent();
      parent.attr('data-original-title', 'URL copied!');
      parent.tooltip('show');
      parent.attr('data-original-title', 'Copy Poll URL');
    }
  });

  // Shrink invitee name/email text size if it is too large to fit in the table cell
  $('div#invitees td span').each(function(){
    var stringLength = $(this).html().length;
    var span = $(this);

    if (stringLength > 60) {
      span.css('font-size','0.8em');
    }
    else if (stringLength > 55) {
      span.css('font-size','0.85em');
    }
    else if (stringLength > 50) {
      span.css('font-size','0.9em');
    }

    if ($(this).hasClass('event-creator')) {
      span.css('font-size','1em');
    }
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
      ).success(function()
        {
          $('.event-name h1').text($('.event-name input').val());
          $('.event-name input').hide();
          $('.event-name h1').show();
        }
      );
  })
});
