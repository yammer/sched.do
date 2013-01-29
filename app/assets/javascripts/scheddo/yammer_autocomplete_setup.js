Scheddo.autocompleteConfiguration = function(options){
  renderUsers = function(ul, users) {
    if(users){
      var userHeader = Scheddo.
        Templates.
        getHeaderTemplate({ type: 'people' });

      $(userHeader).appendTo(ul);
      _.each(users,
        function(user) {
          user.render().appendTo(ul);
        });
    }
  };

  renderGroups = function(ul, groups) {
    if(groups){
      var groupHeader = Scheddo.
        Templates.
        getHeaderTemplate({ type: 'groups' });

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
      if(groupedEntities.email){
        groupedEntities.email[0].render().appendTo(ul);
      }

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
      appendTo: options.autocompleteListSelector,
      open: function(event, ui){
        options.autocompleteInput.addClass('autocomplete-true')
      },
      close: function(event, ui){
        options.autocompleteInput.removeClass('autocomplete-true')
        options.autocompleteInput.val('');
      },
      select: function(event, ui) {
        ui.item.submit(event, $(this).parents('form'));
      },
      source: function(request, response) {
        var yammerApi = Scheddo.YammerApi;

        yammerApi.setAccessToken(Scheddo.YammerApi.userAccessToken);
        yammerApi.autocomplete(options.translator).
          ranked(request.term, response, options.maxUsersReturned);
      }
    }
  };
};
