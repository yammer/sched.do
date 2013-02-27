describe ('Scheddo.YammerApi.setAccessToken', function(){
  it ('sets the users access token on yammer.request for oauth2', function(){
    authSetter = {
      setAuthToken: function(){
      }
    }
    spyOn(authSetter, 'setAuthToken');
    window.yam = {
      request: {
        setAuthenticator: jasmine.createSpy('yam.request.setAuthenticator'),
        getAuthenticator: function(){
          return authSetter;
        }
      }
    }
    var access_token = '123456';
    var api = Scheddo.YammerApi;
    api.setAccessToken(access_token);

    expect(yam.request.setAuthenticator).toHaveBeenCalledWith('oauth2');
    expect(authSetter.setAuthToken).toHaveBeenCalledWith(access_token);
  });
});

describe('Scheddo.YammerApi.autocomplete', function(){
  beforeEach(function(){
    window.yam = {
      request: jasmine.createSpy('yam.request')
    };
  });


  describe('ranked', function(){
    it('passes the correct default arguments to yam.request', function(){
      var term = 'foobar';
      var translateResponseData = jasmine.
        createSpy('translateResponseData');
      spyOn(
        Scheddo.Translators.FullResults,
        'normalizeTranslatedResponse'
      ).andReturn(translateResponseData);

      var autocomplete = Scheddo.YammerApi.autocomplete(
        Scheddo.Translators.FullResults
      );

      autocomplete.ranked(term, null);

      expect(yam.request).toHaveBeenCalledWith({
        url: '/api/v1/autocomplete/ranked',
        method: 'GET',
        data: {'prefix':term,'models' :'user:3,group:2'},
        success: translateResponseData
      });
    });

    it('passes the correct argument for setting max user results to yam.request', function(){
      var term = 'foobar';
      var translateResponseData = jasmine.
        createSpy('translateResponseData');
      spyOn(
        Scheddo.Translators.FullResults, 
        'normalizeTranslatedResponse'
      ).andReturn(translateResponseData);

      var autocomplete = Scheddo.YammerApi.autocomplete(
        Scheddo.Translators.FullResults
      );

      autocomplete.ranked(term, null, 99);

      expect(yam.request).toHaveBeenCalledWith({
        url: '/api/v1/autocomplete/ranked',
        method: 'GET',
        data: {'prefix':term,'models' :'user:99,group:2'},
        success: translateResponseData
      });
    });
  });

});
