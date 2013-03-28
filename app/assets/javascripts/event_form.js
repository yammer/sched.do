Namespaced.declare('Scheddo');

$(document).ready(function() {
  $(document).
    on(
      'mouseenter',
      'div.nested-fields.secondary',
      function() {
        if($(this).siblings().hasClass('secondary')) {
          $(this).children('a.remove_fields').css('display', 'block');
        }
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
    Scheddo.Util.datepicker();
    Scheddo.Util.placeholderPolyfill();
  }

  init();

  // Prevent initial primary suggestion fields from animating
  $('div.nested-fields.primary').addClass('initial');

  // Warn user of unsaved changes when navigating away from page
  var formClean = $("#new_event").serialize();

  window.addEventListener('beforeunload', warnChanges);

    function warnChanges(eventObject){
      var formDirty = $("#new_event").serialize();
      var confirmationMessage = "Your changes will not be saved.";

      if(formClean !== formDirty){
        (eventObject || window.event).returnValue = confirmationMessage; //Gecko and IE
        return confirmationMessage; //Webkit, Safari, Chrome
      }
    }

  $("#new_event").submit(function(){
    window.removeEventListener('beforeunload', warnChanges);
  });
});
