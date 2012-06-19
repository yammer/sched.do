$(document).ready(function() {

  var datepicker = function(){

    // Displays a date/time picker when suggetsion field is focused
    $('input[data-role="suggestion"]').datetimepicker({
      nextText: "▶",
      prevText: "◀",
      timeFormat: 'hh:mmtt z',
      dateFormat: 'D, dd M yy',
      constrainInput: false,
      ampm: true,
      stepMinute: 10,
      hour: 9,
      minute: 20,
      timezone: '',
      showTimezone: true,
      addSliderAccess: true,
      showOptions: {direction: 'down'},
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

  $.extend($.datepicker,{_checkOffset:function(inst,offset,isFixed){return offset}});
  var forms = $('form[id*=new_event], form[id*="edit_event"]');

  forms.bind('insertion-callback', function(){
    datepicker();

    // Animate new nodes
    var lastNode =  forms.find('div.nested-fields:last');
    lastNode.addClass('animated');

    // Focus new nodes
    lastNode.find('input').delay(1000).queue(function() { $(this).focus(); })
  });

});
