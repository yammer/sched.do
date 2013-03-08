Namespaced.declare('Scheddo.Templates');

_.extend(Scheddo.Templates, {
  getGroupListItem: function(params) {
    Scheddo.Util.configureUnderscore();
    return $.trim(_.template($('#group-list-item').html(), params));
  }
});
