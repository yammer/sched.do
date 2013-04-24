$(document).ready(function(){
  $('.dialog-modal').dialog({
    autoOpen: false,
    modal: true,
    width: 500,
    open: function(event, ui) {
      var groupList = $(this).find('.groups');
      if(groupList.children().size() === 1) {
        Scheddo.YammerApi.getGroups(function(groupsData) {
          _.each(groupsData, function(group) {
            groupList.append(Scheddo.Templates.getGroupListItem(group));
          });
        });
      }
    }
  });

  $('.group-list').click(function() {
    $(this).find('.groups').toggle();
  });

  $('.group-list').mouseleave(function() {
    $(this).find('.groups').toggle();
  });

  $('.groups').on('click', '.group', function() {
    $('.groups:visible').toggle();
  });

  $('.dialog_link').click(function() {
    $('.footer-link').dialog('open');
    return false;
  });

  $('.share-button').click( function(event) {
    event.preventDefault();
    var message = $('.dialog-modal textarea:visible').val();
    var group_id = $('.dialog-modal textarea:visible').data('group-id');

    Scheddo.YammerApi.groupMessage(message, group_id);

    $('.dialog-modal').dialog('close');
  });

  $('.selectable').selectable({
    selected: function(event, ui) {
      $('.dialog-modal textarea:visible')
        .data('group-id', $(ui.selected).data('group-id'));
      $('.recipients').text($(ui.selected).text());
    }
  });
});
