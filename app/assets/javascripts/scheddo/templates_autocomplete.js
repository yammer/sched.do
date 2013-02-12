Namespaced.declare('Scheddo.Templates');

_.extend(Scheddo.Templates, {
  getHeaderTemplate: function(params) {
    Scheddo.Util.configureUnderscore();
    return _.template($('#header').html(), params).trim();;
  },

  getUserMenuItemTemplate: function(params) {
    Scheddo.Util.configureUnderscore();
    return _.template($('#userMenuItem').html(), params).trim();
  },

  getGroupMenuItemTemplate: function(params) {
    Scheddo.Util.configureUnderscore();
    return _.template($('#groupMenuItem').html(), params).trim();;
  },

  getEmailItemTemplate: function(params) {
    Scheddo.Util.configureUnderscore();
    return _.template($('#emailItem').html(), params).trim();;
  }
});
