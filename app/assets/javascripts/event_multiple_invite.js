$(document).ready(function(){
  var autocomplete = $('#auto-complete');

  $.widget(
    'custom.yammerAutocomplete',
    $.ui.autocomplete,
    Scheddo.autocompleteConfiguration({
      translator: Scheddo.Translators.MultiInvite,
      autocompleteListSelector: '.invitation-autocomplete-suggestions',
      autocompleteInput: autocomplete
    })
  );

  autocomplete.yammerAutocomplete();

  $('#invitations, #new_event').submit(function(event){
    event.preventDefault();
  });

  $('#multi-invite-submit').on('click', function(event){
    if(Scheddo.Util.inviteeQueue.length > 0){
      $(this).val('Loading...');
      $("input[data-role='invitation_name']").prop('disabled', true);

      _.each(Scheddo.Util.inviteeQueue, function(element, index){
        element.post($('#event_id').val());
      });
    }
    else{
      $('#new_event').unbind('submit');
      $('#new_event').submit();
    }
  });

  $('.back').on('click', function(event){
    if(Modernizr.localstorage){
      sessionStorage.setItem(
        'scheddoInvitees',
        JSON.stringify(Scheddo.Util.inviteeQueue)
      );
    };
  });


  if(Modernizr.localstorage){
    if(sessionStorage.getItem('scheddoInvitees')){
      var parsedInvitees = JSON.parse(sessionStorage.getItem('scheddoInvitees'));
      sessionStorage.removeItem('scheddoInvitees');

      var inviteesGroupedByType = _.groupBy(
        parsedInvitees,
        function(invitee) { return invitee.type; }
      );

      _.each(inviteesGroupedByType['user'], function(invitee){
        Scheddo.
          Translators.
          MultiInvite.
          addMethodsToUser(invitee).
          submit();
      });

      _.each(inviteesGroupedByType['group'], function(invitee){
        Scheddo.
          Translators.
          MultiInvite.
          addMethodsToGroup(invitee).
          submit();
      });

      _.each(inviteesGroupedByType['email'], function(invitee){
        Scheddo.
          Translators.
          MultiInvite.
          addMethodsToEmail(invitee).
          submit();
      });
    };
  }
});
