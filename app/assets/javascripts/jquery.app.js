$(document).ready(function() {
  $('input[data-role="suggestion"]').datetimepicker({
    nextText: "▶",
    prevText: "◀",
    showTimezone: true,
    addSliderAccess: true,
    sliderAccessArgs: { touchonly: true },
    timezoneList: [
      { value: '-1100', label: '-11h NUT' },
      { value: '-1000', label: '-10h HST' },
      { value: '-0900', label: '-09h HDT' },
      { value: '-0800', label: '-08h PST' },
      { value: '-0700', label: '-07h PDT' },
      { value: '-0600', label: '-06h CST' },
      { value: '-0500', label: '-05h EST' },
      { value: '-0400', label: '-04h EDT' },
      { value: '-0300', label: '-03h BRT' },
      { value: '-0200', label: '-02h BRST' },
      { value: '-0100', label: '-01h CVT' },
      { value: '+0000', label: '±00h UTC' },
      { value: '+0100', label: '+01h CET' },
      { value: '+0200', label: '+02h CEST' },
      { value: '+0300', label: '+03h AST' },
      { value: '+0400', label: '+04h MSK' },
      { value: '+0500', label: '+05h PKT' },
      { value: '+0600', label: '+06h BST' },
      { value: '+0700', label: '+07h ICT' },
      { value: '+0800', label: '+08h CST' },
      { value: '+0900', label: '+09h JST' },
      { value: '+1000', label: '+10h AEST' },
      { value: '+1100', label: '+11h AEDT' },
      { value: '+1200', label: '+12h NZST' },
      { value: '+1300', label: '+13h NZDT' }
    ]
  });

  $('.custom-select select').append('content');
});
