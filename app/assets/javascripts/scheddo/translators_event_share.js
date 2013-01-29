Namespaced.declare('Scheddo.Translators');

Scheddo.Translators.EventShare = {
  addMethodsToGroup: function(group){
    group.submit = function(event, form){
      Scheddo.Util.inviteeQueue.push(group);
      Scheddo.
        Translators.
        RenderInInviteeList.
        renderGroup(group);
    };

    return group;
  },

  translateGroups: function(groupData){
    var self = this;
    return _(groupData).map(function(groupObject) {
      var group = Scheddo.Translators.translateGroup(groupObject);
      return self.addMethodsToGroup(group);
    }).reverse();
  },

  normalizeTranslatedResponse: function(term, response){
    var self = this;
    return function(yammerData){
      var groups = self.translateGroups(yammerData.group);

      response(groups);
    }
  }
};
