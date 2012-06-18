$(document).ready(function() {

  var datepicker = function(){

    // Displays a date/time picker when suggetsion field is focused
    $('input[data-role="suggestion"]').datetimepicker({
      nextText: "▶",
      prevText: "◀",
      timeFormat: 'hh:mm tt z',
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
        { value: 'NUT', label: '-11h NUT' },
        { value: 'HST', label: '-10h HST' },
        { value: 'HDT', label: '-09h HDT' },
        { value: 'PST', label: '-08h PST' },
        { value: 'PDT', label: '-07h PDT' },
        { value: 'CST', label: '-06h CST' },
        { value: 'EST', label: '-05h EST' },
        { value: 'EDT', label: '-04h EDT' },
        { value: 'BRT', label: '-03h BRT' },
        { value: 'BRST', label: '-02h BRST' },
        { value: 'CVT', label: '-01h CVT' },
        { value: 'UTC', label: '±00h UTC' },
        { value: '', label: 'Not Set' },
        { value: 'CET' , label: '+01h CET' },
        { value: 'CEST', label: '+02h CEST' },
        { value: 'AST' , label: '+03h AST' },
        { value: 'MSK' , label: '+04h MSK' },
        { value: 'PKT' , label: '+05h PKT' },
        { value: 'BST' , label: '+06h BST' },
        { value: 'ICT' , label: '+07h ICT' },
        { value: 'CST' , label: '+08h CST' },
        { value: 'JST' , label: '+09h JST' },
        { value: 'AEST', label: '+10h AEST' },
        { value: 'AEDT', label: '+11h AEDT' },
        { value: 'NZST', label: '+12h NZST' },
        { value: 'NZDT', label: '+13h NZDT' }
        ]
    });
  };

  datepicker();

  //Prevent default datepicker positioning behavior on top nodes (always display below)
  $.extend($.datepicker,{_checkOffset:function(inst,offset,isFixed){return offset}});

  $('form[id*=new_event], form[id*="edit_event"]').bind('insertion-callback', function(){
    datepicker();

    // Animate new nodes
    var forms = $(this);
    var lastNode =  forms.find('div.nested-fields:last');
    lastNode.addClass('animated');

    // Focus new nodes
    lastNode.find('input').delay(1000).queue(function() { $(this).focus(); })


    // Restore default positioning behavior in lower nodes
    var position = forms.find('div.nested-fields').index(lastNode);
    if (position >= 4) {
      $.extend($.datepicker,{_checkOffset:function(inst,offset,isFixed)
       {
         // Original code from jQuery UI
          var dpWidth = inst.dpDiv.outerWidth();
          var dpHeight = inst.dpDiv.outerHeight();
          var inputWidth = inst.input ? inst.input.outerWidth() : 0;
          var inputHeight = inst.input ? inst.input.outerHeight() : 0;
          var viewWidth = document.documentElement.clientWidth + $(document).scrollLeft();
          var viewHeight = document.documentElement.clientHeight + $(document).scrollTop();

          offset.left -= (this._get(inst, 'isRTL') ? (dpWidth - inputWidth) : 0);
          offset.left -= (isFixed && offset.left == inst.input.offset().left) ? $(document).scrollLeft() : 0;
          offset.top -= (isFixed && offset.top == (inst.input.offset().top + inputHeight)) ? $(document).scrollTop() : 0;

          offset.left -= Math.min(offset.left, (offset.left + dpWidth > viewWidth && viewWidth > dpWidth) ?
              Math.abs(offset.left + dpWidth - viewWidth) : 0);
          offset.top -= Math.min(offset.top, (offset.top + dpHeight > viewHeight && viewHeight > dpHeight) ?
              Math.abs(dpHeight + inputHeight) : 0);

          return offset;
        }
      });
    };

  });

});
