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

  publicMessage: function(message){
    var flashMessage = function(div, flash) {
      return function(){
        Scheddo.Util.setFlash(div, flash);
      };
    };

    var options = {
      url: '/api/v1/messages.json',
      method: 'POST',
      data: { body: message },
      success: flashMessage('flash-notice', 'Thank you for sharing sched.do!'),
      error: flashMessage('flash-error', 'There was an error with the request')
    };

    yam.request(options);
  },

  autocomplete: function(translator){
    var maxUsersReturned = 3;
    var maxGroupsReturned = 2;
    return {
	    ranked: function(term, response){
	      var options = {
	        url: '/api/v1/autocomplete/ranked',
	        method: 'GET',
	        data: {
            prefix: term,
            models: 'user:' + maxUsersReturned + ',group:' + maxGroupsReturned},
	        success: this.translateResponseData(term, response)
	      };

	      yam.request(options);
	    },

      getUser: function(id, displayCallback){
        var options = {
          url: '/api/v1/users/' + id,
          method: 'GET',
          success: function(yammerData){
            user = _.first(translator.translateUsers([yammerData]));
            displayCallback(user);
          }
        };

        yam.request(options);
      },

      getGroup: function(id, displayCallback){
        var options = {
          url: '/api/v1/groups/' + id,
          method: 'GET',
          success: function(yammerData){
            group = _.first(translator.translateGroups([yammerData]));
            displayCallback(group);
          }
        };

        yam.request(options);
      },

      translateResponseData: function(term, response){
        return function(yammerData){
          var users = translator.translateUsers(yammerData.user);
          var groups = translator.translateGroups(yammerData.group);
          var email = translator.translateEmail(term);
          var items = users.concat(groups);
          items.push(email);

          response(items);
        };
      }
    }
  }
};
