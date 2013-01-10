Namespaced.declare('Scheddo.Util');

_.extend(Scheddo.Util, {
  inviteeQueue: [],

  removeInviteeFromQueue: function(objectToRemove){
    var index = Scheddo.Util.inviteeQueue.indexOf(objectToRemove);
    Scheddo.Util.inviteeQueue.splice(index, 1);
  }
});
