Namespaced.declare('Scheddo.Templates');

_.extend(Scheddo.Templates, {
  getHeaderTemplate: function(params) {
    Scheddo.Util.configureUnderscore();
    return $.trim(_.template($('#header').html(), params));
  },

  getUserMenuItemTemplate: function(params) {
    Scheddo.Util.configureUnderscore();
    return $.trim(_.template($('#userMenuItem').html(), params));
  },

  getGroupMenuItemTemplate: function(params) {
    Scheddo.Util.configureUnderscore();
    return $.trim(_.template($('#groupMenuItem').html(), params));
  },

  getEmailItemTemplate: function(params) {
    Scheddo.Util.configureUnderscore();
    return $.trim(_.template($('#emailItem').html(), params));
  }
});
