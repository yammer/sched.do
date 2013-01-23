var scheddo = scheddo || {};

scheddo.yammerApi = function(translator){
  return {
    setAccessToken: function(token){
      yam.request.setAuthenticator('oauth2');
      yam.request.getAuthenticator({ auth: 'oauth2' }).setAuthToken(token);
   },

    publicMessage: function(message){
      var flashMessage = function(div, flash) {
        return function(){
          $('.flash').html(
            scheddo.templates.getShareSuccessTemplate({
              divId: div,
              flashMessage: flash
            })
          );
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

   autocomplete: {
     ranked: function(term, response){
       var options = {
         url: '/api/v1/autocomplete/ranked',
         method: 'GET',
         data: {'prefix':term,'models' :'user:3,group:2'},
         success: this.translateResponseData(term, response)
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
