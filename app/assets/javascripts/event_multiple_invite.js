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
    var invitationText = $('.invitation-text textarea').val().trim();
    var validText = isValidText(invitationText);
    if(Scheddo.Util.inviteeQueue.length > 0 && validText){
      $(this).val('Loading...');
      $("input[data-role='invitation_name']").prop('disabled', true);

      _.each(Scheddo.Util.inviteeQueue, function(element, index){
        var eventId = $('#event_id').val();
        element.post(eventId, invitationText);
      });
    }
    else if(validText === false) {
      $('.flash').append('<div id="flash-error">Invitation text cannot be blank.</div>')
      var defaultText = "I\'m using sched.do to schedule an event, and I\'d like your input.";
      $('.invitation-text textarea').val(defaultText);
    }
    else{
      $('#new_event').unbind('submit');
      $('#new_event').submit();
    }
  });

  isValidText = function(invitationText) {
    if(invitationText.length > 0) {
      return true;
    }
    else {
      return false;
    }
  }

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
