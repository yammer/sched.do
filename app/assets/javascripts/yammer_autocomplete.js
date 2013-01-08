var scheddo = scheddo || {};

scheddo.autocompleteConfiguration = (function(){
  renderUsers = function(ul, users) {
      if(users){
        var userHeader = scheddo.templates.getHeaderTemplate({ type: 'people' });
        $(userHeader).appendTo(ul);
        _.each(users,
          function(user) { user.render().appendTo(ul); });
      }
    };

  renderGroups = function(ul, groups) {
    if(groups){
      var groupHeader = scheddo.templates.getHeaderTemplate({ type: 'groups' });
      $(groupHeader).appendTo(ul);
      _.each(groups,
        function(group) { group.render().appendTo(ul); });
    };
  };

  return {
    _renderMenu: function(ul, items) {
      var groupedEntities = _.groupBy(items, function(item) { return item.type; });

      renderUsers(ul, groupedEntities.user);
      renderGroups(ul, groupedEntities.group);
      groupedEntities.email[0].render().appendTo(ul);

      return ul;
    },
    _renderItem: function(ul, item){
      throw 'This method is no longer implemented. See _renderMenu method above.';
    },
    _renderItemData: function(ul, item){
      throw 'This method is no longer implemented. See _renderMenu method above.';
    },
    options: {
      minLength: 1,
      appendTo: '.invitation-autocomplete-suggestions',
      open: function(event, ui){
        $('#auto-complete').addClass("autocomplete-true")
      },
      close: function(event, ui){
        $('#auto-complete').removeClass("autocomplete-true")
      },
      select: function(event, ui) {
        ui.item.submit(event, $(this).parents('form'));
      },
      source: function(request, response) {
        var yammerApi = scheddo.yammerApi(scheddo.translators.autocomplete);

        yammerApi.setAccessToken(access_token);
        yammerApi.autocomplete.ranked(request.term, response);
      }
    }
  };
})();

$.widget("custom.yammerAutocomplete", $.ui.autocomplete, scheddo.autocompleteConfiguration);

if("access_token" in window){
  $("input[data-role='invitation_name']").yammerAutocomplete();
}
