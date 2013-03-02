$(document).ready(function(){
  $('#sign-in-modal').dialog({ autoOpen: false, modal: true, width: 500 });

  $('#new-event').click(function() {
    $('#sign-in-modal').dialog('open');
    return false;
  });
});
