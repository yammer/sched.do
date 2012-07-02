$(document).ready(function() {

  var datepicker = function(){
    // Displays a date/time picker when suggetsion field is focused
    $('input[data-role="primary-suggestion"]').datepicker({
      nextText: "▶",
      prevText: "◀",
      dateFormat: 'D, M dd yy',
      constrainInput: false,
    });

    $('input[data-role="secondary-suggestion"]').timepicker({
      timeFormat: 'hh:mm TT z',
      constrainInput: false,
      ampm: true,
      stepMinute: 10,
      hour: 0,
      minute: 0,
      timezone: '',
      showTimezone: true,
      timezoneList: [
        { value: 'UTC-11', label: '(-11h) Pago Pago, Alofi' },
        { value: 'UTC-10', label: '(-10h) Honolulu, Papeete' },
        { value: 'UTC-9', label: '(-9h) Anchorage, Juneau' },
        { value: 'UTC-8', label: '(-8h) San Francisco, Vancouver' },
        { value: 'UTC-7', label: '(-7h) Denver, Edmonton' },
        { value: 'UTC-6', label: '(-6h) Chicago, Mexico City' },
        { value: 'UTC-5', label: '(-5h) New York City, Toronto' },
        { value: 'UTC-4', label: '(-4h) Santiago de Chile, Halifax' },
        { value: 'UTC-3', label: '(-3h) Rio de Janeiro, Buenos Aires' },
        { value: 'UTC-2', label: '(-2h) Fernando de Noronha' },
        { value: 'UTC-1', label: '(-1h) Praia, Ponta Delgada' },
        { value: 'UTC', label: '(UTC) London, Lisbon, Casablanca' },
        { value: '', label: 'Not Set' },
        { value: 'UTC+1', label: '(+1h) Madrid, Paris, Berlin, Rome' },
        { value: 'UTC+2', label: '(+2h) Helsinki, Athens, Cairo' },
        { value: 'UTC+3', label: '(+3h) Nairobi, Baghdad, Riyadh' },
        { value: 'UTC+4', label: '(+4h) Dubai, Moscow' },
        { value: 'UTC+5', label: '(+5h) Karachi, Lahore' },
        { value: 'UTC+6', label: '(+6h) Dhaka, Chittagong' },
        { value: 'UTC+7', label: '(+7h) Jakarta, Bangkok' },
        { value: 'UTC+8', label: '(+8h) Beijing, Singapore' },
        { value: 'UTC+9', label: '(+9h) Seoul, Tokyo' },
        { value: 'UTC+10', label: '(+10h) Sydney, Melbourne' },
        { value: 'UTC+11', label: '(+11h) Vladivostok, Noumea' },
        { value: 'UTC+12', label: '(+12h) Auckland, Wellington' },
        ]
    });
  };

  datepicker();

  $.extend($.datepicker,{_checkOffset:function(inst,offset,isFixed){
    var dpHeight = inst.dpDiv.outerHeight();
    var inputHeight = inst.input ? inst.input.outerHeight() : 0;

    offset.top -= dpHeight + inputHeight + 10;
    offset.left -= (window.innerWidth < 430 ? 20 : 0);
    return offset;
  }});

  var forms = $('form[id*=new_event], form[id*="edit_event"]');
  forms.find('div.nested-fields input').removeAttr('maxlength');
  forms.find('div.nested-fields.primary').addClass('animated');


  forms.bind('insertion-callback', function(){
    datepicker();

    // Animate new nodes
    var lastNode =  forms.find('div.nested-fields.primary:last');
    lastNode.addClass('animated');

    $dateTimePickers = forms.find('div.nested-fields input')
    $dateTimePickers.removeAttr('maxlength');
  });

  bind_to_new_time_fields();
  bind_to_changed_primary_fields();

  $('#new_event ol').bind("insertion-callback", function() {
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
});
