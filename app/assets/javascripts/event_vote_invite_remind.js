//= require jquery.event
//= require yammer_feed
//= require votes

$(document).ready(function(){
  var hasLocalStorage = function(action){
    if(Modernizr.localstorage){
      action();
    }
  };

  if(Scheddo.YammerApi.isYammerUser()){
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

    var hasSharedApp;
    hasLocalStorage(function(){
      hasSharedApp = localStorage.getItem('sharedApp');
    });

    if(hasSharedApp === null || !hasSharedApp){
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
        delay(800).
        queue(function() {
          $(this).dialog('open')
        });
      });

      $('.post-vote-button').click(function(event){
        alert('sharing');
        event.preventDefault();
        var message = $('.dialog-modal textarea').val();

        if(Scheddo.Util.inviteeQueue.length > 0){
          _.each(Scheddo.Util.inviteeQueue, function(group){
            Scheddo.YammerApi.groupMessage(message, group);
          });

          Scheddo.Util.inviteeQueue = [];
        }
        else{
          Scheddo.YammerApi.publicMessage(message);
        }

        $('.share-app').dialog('close')
        hasLocalStorage(function(){
          localStorage.setItem('sharedApp', true);
        });
      });
    }
  }
});
