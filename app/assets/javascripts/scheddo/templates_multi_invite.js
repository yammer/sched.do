Namespaced.declare('Scheddo.Templates');

_.extend(Scheddo.Templates, {
  getUserInviteeTemplate: function(params) {
    Scheddo.Util.configureUnderscore();
    return $.trim(_.template($('#userInvitee').html(), params));
  },

  getGroupInviteeTemplate: function(params) {
    Scheddo.Util.configureUnderscore();
    return $.trim(_.template($('#groupInvitee').html(), params));
  },

  getEmailInviteeTemplate: function(params) {
    Scheddo.Util.configureUnderscore();
    return $.trim(_.template($('#emailInvitee').html(), params));
  }
});
