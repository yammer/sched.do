Namespaced.declare('Scheddo.Util');

_.extend(Scheddo.Util, {
  inviteeQueue: [],

  removeInviteeFromQueue: function(objectToRemove){
    var index = _.indexOf(Scheddo.Util.inviteeQueue, objectToRemove);
    Scheddo.Util.inviteeQueue.splice(index, 1);
  }
});
