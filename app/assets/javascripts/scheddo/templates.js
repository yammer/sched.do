var scheddo = scheddo || {};
scheddo.templates = scheddo.templates || {};

scheddo.templates = (function(){
  var configureUnderscore = function(){
    _.templateSettings = {
      interpolate: /\{\{\=(.+?)\}\}/g,
      evaluate: /\{\{(.+?)\}\}/g
    };
  };

  return {
    getHeaderTemplate: function(params) {
      configureUnderscore();
      return _.template($('#header').html(), params);
    },

    getUserMenuItemTemplate: function(params) {
      configureUnderscore();
      return _.template($('#userMenuItem').html(), params);
    },

    getGroupMenuItemTemplate: function(params) {
      configureUnderscore();
      return _.template($('#groupMenuItem').html(), params);
    },

    getEmailItemTemplate: function(params) {
      configureUnderscore();
      return _.template($('#emailItem').html(), params);
    }
  };
})();
