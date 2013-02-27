Namespaced.declare('Scheddo');

$(document).ready(function() {
  var nextDate = null;

  var placeholderPolyfill = function() {
    $('input, textarea').placeholder();
  }

  var setDatepickerDefaultDates = function() {
    $('.primary-suggestion').
      datepicker('option', 'defaultDate', nextDate);
  };

  var datepicker = function() {
    // Displays a date picker when suggetsion field is focused
    $('.primary-suggestion').datepicker({
      nextText: '▶',
      prevText: '◀',
      dateFormat: 'D, M dd yy',
      constrainInput: false,
      onSelect: function() {
        nextDate = $(this).datepicker('getDate');
        nextDate.setDate(nextDate.getDate() + 1);
        setDatepickerDefaultDates();
      }
    });
  };

  var setDefaultDate = function(datepicker) {
    if(nextDate) {
      setDatepickerDefaultDates();
    }
  };

  $(document).
    on(
      'mouseenter',
      'div.nested-fields.secondary',
      function() {
        $(this).children('a.remove_fields').css('display', 'block');
      }
    ).
    on(
      'mouseleave',
      'div.nested-fields.secondary',
      function() {
        $(this).children('a.remove_fields').hide();
      }
    );

  $(document).
    on(
      'mouseenter',
      'div.nested-fields.primary',
      function() {
        $(this).find('div.times > a.remove_fields').css('display', 'block');
      }
    ).
    on(
      'mouseleave',
      'div.nested-fields.primary',
      function() {
        $(this).find('div.times > a.remove_fields').hide();
      }
    );

  $(document).
    on(
      'click',
      'a.remove_fields',
      function() {
        $(this).parents('div.nested-fields').addClass('deleted');
      }
    );

  $(document).
    on(
      'cocoon:after-insert',
      '#new_event, #edit_event',
      function(event, insertedItem) {
        if(insertedItem.hasClass('primary')) {
          init();

          // Animate new nodes
          $(this).
            find('div.nested-fields.primary:not(".initial"):last').
            addClass('animated');

          $('#new_event ol .nested-fields .add_fields:last').click();
        }
      }
    );

  $.extend($.datepicker,{
    _checkOffset: function(inst, offset, isFixed) {
      var dpHeight = inst.dpDiv.outerHeight();
      var inputHeight = inst.input ? inst.input.outerHeight() : 0;

      offset.top -= dpHeight + inputHeight + 10;
      offset.left -= (window.innerWidth < 430 ? 20 : 0);
      return offset;
    }
  });

  var init = function() {
    datepicker();
    placeholderPolyfill();
  }

  init();

  // Prevent initial primary suggestion fields from animating
  $('div.nested-fields.primary').addClass('initial');
});
