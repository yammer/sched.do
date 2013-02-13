$(document).ready(function(){
  Namespaced.declare('Scheddo');

  Scheddo.setNextDatePicker = function() {
    nextDateField = $(this).parent().
      parent().
      parent().
      next().
      find('input[data-role="primary-suggestion"]');
    nextDate = $(this).datepicker('getDate');
    nextDate.setDate(nextDate.getDate()+1);
    $(nextDateField).datepicker('option', 'defaultDate', nextDate);
  }

  if (!Modernizr.cssanimations) {
    $('.flash > div').delay(1500).slideUp()
  }
  $('a[rel*=yammer-invite]').leanModal({ closeButton: '.modal-close' })
  $('a[rel*=email-invite]').leanModal({ closeButton: '.modal-close' })

  var placeholderPolyfill = function() {
    $('input, textarea').placeholder();
  }

  var datepicker = function(){
    // Displays a date picker when suggetsion field is focused
    $('input[data-role="primary-suggestion"]').datepicker({
      nextText: '▶',
      prevText: '◀',
      dateFormat: 'D, M dd yy',
      constrainInput: false,
      onSelect: Scheddo.setNextDatePicker
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

  forms.bind('cocoon:after-insert', function(){
    datepicker();
    addRemovalAnimation();
    showRemoveIcons();
    placeholderPolyfill();

    // Animate new nodes
    var lastNode =  forms.find('div.nested-fields.primary:not(".initial"):last');
    lastNode.addClass('animated');

    $dateTimePickers = forms.find('div.nested-fields input')
    $dateTimePickers.removeAttr('maxlength');
  });

  // Prevent initial primary suggestion fields from animating
  $('div.nested-fields.primary').addClass('initial');

  bindToNewTimeFields();
  bindToChangedPrimaryFields();

  $('#new_event ol').bind('cocoon:after-insert', function() {
    setDefaultDate();
    bindToNewTimeFields();
    bindToChangedPrimaryFields();
  });

  function bindToNewTimeFields() {
    $('.nested-fields.primary').bind('cocoon:after-insert', function() {
      var primarySuggestions = $(this).find('[data-role="primary-suggestion"]');
      var primarySuggestionValue = primarySuggestions.first().val();
      primarySuggestions.last().val(primarySuggestionValue);
    });
  }

  function bindToChangedPrimaryFields() {
    $('[data-role="primary-suggestion"]').change(function() {
      var primarySuggestions = $(this).parents('.nested-fields.primary')
        .first().find('[data-role="primary-suggestion"]');
      var primarySuggestionValue = primarySuggestions.first().val();
      primarySuggestions.each(function(index) {
        $(this).val(primarySuggestionValue);
      });
    });
  }

  function setDefaultDate(){
   previousDate = $('input[data-role="primary-suggestion"]')
      .eq(-2)
      .datepicker('getDate')
    if(previousDate){
      previousDate.setDate(previousDate.getDate()+1);
      setTimeout( function(){
        $('input[data-role="primary-suggestion"]:last').data('datepicker').settings.defaultDate=previousDate;
      }, 10);
    }
  }

  placeholderPolyfill();
});
