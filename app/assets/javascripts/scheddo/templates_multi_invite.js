Namespaced.declare('Scheddo.Templates');

_.extend(Scheddo.Templates, {
  getUserInviteeTemplate: function(params) {
    Scheddo.Util.configureUnderscore();
    return _.template($('#userInvitee').html(), params).trim();
  },

  getGroupInviteeTemplate: function(params) {
    Scheddo.Util.configureUnderscore();
    return _.template($('#groupInvitee').html(), params).trim();;
  },

  getEmailInviteeTemplate: function(params) {
    Scheddo.Util.configureUnderscore();
    return _.template($('#emailInvitee').html(), params).trim();;
  }
});
