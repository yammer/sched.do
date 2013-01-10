Scheddo.autocompleteConfiguration = function(translator){
  renderUsers = function(ul, users) {
    if(users){
      var userHeader = Scheddo.Templates.getHeaderTemplate({ type: 'people' });
      $(userHeader).appendTo(ul);
      _.each(users,
        function(user) {
          user.render().appendTo(ul);
        });
    }
  };

  renderGroups = function(ul, groups) {
    if(groups){
      var groupHeader = Scheddo.Templates.getHeaderTemplate({ type: 'groups' });
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
      autoFocus: true,
      delay: 250,
      minLength: 1,
      appendTo: '.invitation-autocomplete-suggestions',
      open: function(event, ui){
        $('#auto-complete').addClass('autocomplete-true')
      },
      close: function(event, ui){
        $('#auto-complete').removeClass('autocomplete-true')
        $('#auto-complete').val('');
      },
      select: function(event, ui) {
        $('#auto-complete').val(ui.item.value);
        ui.item.submit(event, $(this).parents('form'));
      },
      source: function(request, response) {
        var yammerApi = Scheddo.YammerApi;

        yammerApi.setAccessToken(Scheddo.YammerApi.userAccessToken);
        yammerApi.autocomplete(translator).ranked(request.term, response);
      }
    }
  };
};
