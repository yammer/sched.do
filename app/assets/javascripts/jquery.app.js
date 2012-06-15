$(document).ready(function() {

  var datepicker = function(){

    // Displays a date/time picker when suggetsion field is focused
    // $('input[data-role="suggestion"]').datetimepicker({
    //   nextText: "▶",
    //   prevText: "◀",
    //   timeFormat: 'hh:mm tt z',
    //   dateFormat: 'D, dd M yy',
    //   constrainInput: false,
    //   ampm: true,
    //   stepMinute: 10,
    //   hour: 9,
    //   minute: 20,
    //   timezone: '',
    //   showTimezone: true,
    //   addSliderAccess: true,
    //   timezoneList: [
    //     { value: 'NUT', label: '-11h NUT' },
    //     { value: 'HST', label: '-10h HST' },
    //     { value: 'HDT', label: '-09h HDT' },
    //     { value: 'PST', label: '-08h PST' },
    //     { value: 'PDT', label: '-07h PDT' },
    //     { value: 'CST', label: '-06h CST' },
    //     { value: 'EST', label: '-05h EST' },
    //     { value: 'EDT', label: '-04h EDT' },
    //     { value: 'BRT', label: '-03h BRT' },
    //     { value: 'BRST', label: '-02h BRST' },
    //     { value: 'CVT', label: '-01h CVT' },
    //     { value: 'UTC', label: '±00h UTC' },
    //     { value: '', label: 'Not Set' },
    //     { value: 'CET' , label: '+01h CET' },
    //     { value: 'CEST', label: '+02h CEST' },
    //     { value: 'AST' , label: '+03h AST' },
    //     { value: 'MSK' , label: '+04h MSK' },
    //     { value: 'PKT' , label: '+05h PKT' },
    //     { value: 'BST' , label: '+06h BST' },
    //     { value: 'ICT' , label: '+07h ICT' },
    //     { value: 'CST' , label: '+08h CST' },
    //     { value: 'JST' , label: '+09h JST' },
    //     { value: 'AEST', label: '+10h AEST' },
    //     { value: 'AEDT', label: '+11h AEDT' },
    //     { value: 'NZST', label: '+12h NZST' },
    //     { value: 'NZDT', label: '+13h NZDT' }
    //     ]
    // });

  };

  datepicker();
  $('form[id*=new_event], form[id*="edit_event"]').bind('insertion-callback', datepicker);

});
