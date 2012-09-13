YammerApi = {
  setAccessToken: function(token){
   yam.request.setAuthenticator('oauth2');
   yam.request.getAuthenticator({ auth: 'oauth2' }).setAuthToken(token);
  },

  autocomplete: {
    get: function(term, autocompleteCallback){
      var options = {
        url: '/api/v1/autocomplete/ranked',
        method: 'GET',
        data: {'prefix':term,'models' :'user:3,group:2'},
        success: YammerApi.autocomplete.successCallback(autocompleteCallback, term)
      };
      yam.request(options);
    },

    successCallback: function(autocompleteCallback, term){
      return function(yammerData){
        var users = _(yammerData.user)
        .map(function(userObject) {
          return {
            label: userObject.full_name,
            value: userObject.full_name,
            photo: userObject.photo,
            yammerUserId: userObject.id,
            ranking: userObject.ranking,
            jobTitle: userObject.job_title,
            type: 'user'
          };
        })

        users = _(users)
          .sortBy(function(user){
            return -user.ranking;
          });

        var groups = _(yammerData.group)
          .map(function(groupObject) {
            return {
              label: groupObject.full_name,
              value: groupObject.full_name,
              photo: groupObject.photo,
              yammerGroupId: groupObject.id,
              ranking: groupObject.ranking,
              type: 'group'
            };
          })

        groups = _(groups)
          .sortBy(function(group){
            return -group.ranking;
          });

        email = {
          label: term,
          value: term,
          type: 'email'
        }

        users_groups_and_email = users.concat(groups)
        users_groups_and_email.push(email)
        autocompleteCallback(users_groups_and_email);
      };
    }
  }
};
