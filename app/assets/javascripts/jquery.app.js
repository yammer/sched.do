 var setNextDatePicker = function () {
    nextDateField = $(this)
            .parent()
            .parent()
            .parent()
            .next()
            .find('input[data-role="primary-suggestion"]');
    nextDate = $(this).datepicker('getDate');
    nextDate.setDate(nextDate.getDate()+1);
    $(nextDateField).datepicker("option", "defaultDate", nextDate);
}

$(document).ready(function() {
  $("#new-event").leanModal({closeButton: ".modal-close"})
  $("a[rel*=yammer-invite]").leanModal({closeButton: ".modal-close"})
  $("a[rel*=email-invite]").leanModal({closeButton: ".modal-close"})

  var placeholderPollyfill = function() {
    $('input, textarea').placeholder();
  }

  var datepicker = function(){
    // Displays a date picker when suggetsion field is focused
    $('input[data-role="primary-suggestion"]').datepicker({
      nextText: "▶",
      prevText: "◀",
      dateFormat: 'D, M dd yy',
      constrainInput: false,
      onSelect: setNextDatePicker
    });
  };

  var addRemovalAnimation = function() {
    $('div.primary > div.times > a.remove_fields').click(function(){
      $(this).parents('div.nested-fields').addClass('deleted');
    });

    $('div.secondary a.remove_fields').click(function(){
      $(this).parent('div.nested-fields').addClass('deleted');
    });
  };

  // Show delete button on hover
  var showRemoveIcons = function() {
    var primary = $('div.nested-fields.primary');
    var secondary = $('div.nested-fields.secondary');

    secondary.hover(function(){
      $(this).children('a.remove_fields').css('display', 'block');
    },
    function(){
      $(this).children('a.remove_fields').hide();
    });

    primary.hover(function(){
      if(forms.find('div.nested-fields.primary:not(.deleted)').length != 1){
        $(this).find('div.times > a.remove_fields').css('display', 'block');
      }
    },
    function(){
      if(forms.find('div.nested-fields.primary').length != 1){
        $(this).find('div.times > a.remove_fields').hide();
      }
    });
  }

  datepicker();
  addRemovalAnimation();
  showRemoveIcons();

  $.extend($.datepicker,{_checkOffset:function(inst,offset,isFixed){
    var dpHeight = inst.dpDiv.outerHeight();
    var inputHeight = inst.input ? inst.input.outerHeight() : 0;

    offset.top -= dpHeight + inputHeight + 10;
    offset.left -= (window.innerWidth < 430 ? 20 : 0);
    return offset;
  }});

  var forms = $('form[id*=new_event], form[id*="edit_event"]');
  forms.find('div.nested-fields input').removeAttr('maxlength');

  forms.bind('insertion-callback', function(){
    datepicker();
    addRemovalAnimation();
    showRemoveIcons();
    placeholderPollyfill();

    // Animate new nodes
    var lastNode =  forms.find('div.nested-fields.primary:not(".initial"):last');
    lastNode.addClass('animated');

    $dateTimePickers = forms.find('div.nested-fields input')
    $dateTimePickers.removeAttr('maxlength');
  });

  // Prevent initial primary suggestion fields from animating
  $('div.nested-fields.primary').addClass('initial');

  bind_to_new_time_fields();
  bind_to_changed_primary_fields();

  $('#new_event ol').bind("insertion-callback", function() {
    set_default_date();
    bind_to_new_time_fields();
    bind_to_changed_primary_fields();
  });

  function bind_to_new_time_fields() {
    $('.nested-fields.primary').bind("insertion-callback", function() {
      var primary_suggestions = $(this).find("[data-role='primary-suggestion']");
      var primary_suggestion_value = primary_suggestions.first().val();
      primary_suggestions.last().val(primary_suggestion_value);
    });
  }

  function bind_to_changed_primary_fields() {
    $("[data-role='primary-suggestion']").change(function() {
      var primary_suggestions = $(this).parents('.nested-fields.primary')
        .first().find("[data-role='primary-suggestion']");
      var primary_suggestion_value = primary_suggestions.first().val();
      primary_suggestions.each(function(index) {
        $(this).val(primary_suggestion_value);
      });
    });
  }

  function set_default_date(){
   previousDate = $('input[data-role="primary-suggestion"]')
      .eq(-2)
      .datepicker('getDate')
    if(previousDate){
      previousDate.setDate(previousDate.getDate()+1);
      setTimeout( function(){
        $('input[data-role="primary-suggestion"]:last').datepicker("option", "defaultDate", previousDate);
      }, 10);
    }
  }

  // Select event URL on click
   $("input#event-url").click(function() {
     $(this).select();
   });

  // Enable dragging in touch devices on tables
  if (Modernizr.touch) {
    $('table.touch-scrollable').addClass("scrollable horizontal")
  }

  // Enable click-to-copy
  var clip = new ZeroClipboard.Client();

  clip.addEventListener( 'mouseDown', function(client) {
    clip.setText( $('div.copy-event-url').data('event-url'));
    $('div.copy-event-url').text('URL Is Copied');
  });

  if( $('#copy-event-url').length > 0) {
    clip.glue( 'copy-event-url', 'copy-url-container' );
  }

  $(window).resize(function(){
    clip.reposition();
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

    if ($(this).hasClass("event-creator")) {
      span.css('font-size','1em');
    }
  });

  placeholderPollyfill();

});
