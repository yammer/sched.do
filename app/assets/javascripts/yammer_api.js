YammerApi = {
  setAccessToken: function(token){
   yam.request.setAuthenticator('oauth2');
   yam.request.getAuthenticator({ auth: 'oauth2' }).setAuthToken(token);
  },

  autocomplete: {
    get: function(term, autocompleteCallback){
      var options = {
        url: '/api/v1/autocomplete.json',
        method: 'GET',
        data: 'prefix=' + term,
        success: YammerApi.autocomplete.successCallback(autocompleteCallback)
      };
      yam.request(options);
    },

    successCallback: function(autocompleteCallback){
      return function(yammerData){
        var users = _.map(yammerData.users, function(userObject) {
          return { label: userObject.full_name,
                   value: userObject.full_name,
                   yammerUserId: userObject.id };
        });
        autocompleteCallback(users);
      };
    }
  }
};

