//= require jquery.event
//= require yammer_feed
//= require votes

$(document).ready(function(){
  if(Scheddo.YammerApi.isYammerUser()) {
    var eventInviteAutocomplete = $('#auto-complete');
    var shareAppAutocomplete = $('.share-app #auto-complete');

    $.widget('custom.yammerAutocomplete',
      $.ui.autocomplete,
        Scheddo.autocompleteConfiguration({
          translator: Scheddo.Translators.SingleInvite,
          autocompleteListSelector: '.invitation-autocomplete-suggestions',
          autocompleteInput: eventInviteAutocomplete
        }));
    eventInviteAutocomplete.yammerAutocomplete();

    $.widget('custom.yammerShareAutocomplete',
      $.ui.autocomplete,
        Scheddo.autocompleteConfiguration({
          translator: Scheddo.Translators.EventShare,
          autocompleteListSelector: '.share-app .invitation-autocomplete-suggestions',
          maxUsersReturned: 0,
          autocompleteInput: shareAppAutocomplete
        }));

    shareAppAutocomplete.yammerShareAutocomplete();

    $('.votable').one('click', '.vote', function() {
      $('.post-vote').
      delay(45000).
      queue(function() {
        $(this).dialog('open')
      });
    });
  }
  else {
    $('#invitations').keypress(function(event) {
      var keycode = (event.keyCode ? event.keyCode : event.which);
      if(keycode == '13') {
        $('#invitations').submit();
       }
    });
  }
});
