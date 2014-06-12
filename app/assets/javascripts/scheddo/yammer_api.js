Namespaced.declare('Scheddo');

Scheddo.YammerApi = {
  userAccessToken: undefined,

  isYammerUser: function(){
    return typeof this.userAccessToken !== 'undefined';
  },

  setAccessToken: function(token){
    yam.request.setAuthenticator('oauth2');
    yam.request.getAuthenticator({ auth: 'oauth2' }).setAuthToken(token);
  },

  groupMessage: function(message, group_id){
    var flashMessage = function(div, flash) {
      return function(){
        Scheddo.Util.setFlash(div, flash);
      };
    };

    var options = {
      url: 'messages.json',
      method: 'POST',
      data: {
        body: message,
        group_id: group_id
      },
      success: flashMessage('flash-notice', 'Thank you for sharing sched.do!'),
      error: flashMessage('flash-error', 'There was an error with the request')
    };

    yam.platform.request(options);
  },

  publicMessage: function(message){
    var flashMessage = function(div, flash) {
      return function(){
        Scheddo.Util.setFlash(div, flash);
      };
    };

    var options = {
      url: 'messages.json',
      method: 'POST',
      data: { body: message },
      success: flashMessage('flash-notice', 'Thank you for sharing sched.do!'),
      error: flashMessage('flash-error', 'There was an error with the request')
    };

    yam.platform.request(options);
  },

  getGroups: function(callback){
    var options = {
      url: 'groups.json',
      method: 'GET',
      success: function(yammerData){
        groups = _.map(
          yammerData,
          Scheddo.Translators.translateGroup
        );
        callback(groups);
      }
    };

    yam.platform.request(options);
  },

  autocomplete: function(translator){
    var maxGroupsReturned = 2;
    return {
      ranked: function(term, response, maxUsersReturned){
        if(typeof maxUsersReturned === 'undefined') {
          maxUsersReturned = 3
        };

        var options = {
          url: 'autocomplete/ranked',
          method: 'GET',
          data: {
            prefix: term,
            models: 'user:' + maxUsersReturned + ',group:' + maxGroupsReturned},
          success: translator.normalizeTranslatedResponse(term, response)
        };

        yam.platform.request(options);
      }
    }
  }
};
