$(document).ready(function(){
  $('.dialog-modal').dialog({ autoOpen: false, modal: true, width: 500 });

  $('.dialog_link').click(function() {
    $('.footer-link').dialog('open');
    return false;
  });

  $('.footer-link-button').click( function(event) {
    event.preventDefault();
    var message = $('.dialog-modal textarea').val();

    Scheddo.YammerApi.publicMessage(message);

    $('.footer-link').dialog('close');
  });
});
