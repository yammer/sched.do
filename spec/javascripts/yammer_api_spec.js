require('/assets/yammer_api.js');
require('/assets/underscore.js');

describe ('YammerApi.setAccessToken', function(){
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

    YammerApi.setAccessToken(access_token);

    expect(yam.request.setAuthenticator).toHaveBeenCalledWith('oauth2');
    expect(authSetter.setAuthToken).toHaveBeenCalledWith(access_token);
  });
});

describe('YammerApi.autocomplete', function(){
  beforeEach(function(){
    window.yam = {
      request: jasmine.createSpy('yam.request')
    };
  });


  describe('.get', function(){
    it('passes the correct arguments to yam.request', function(){
      var term = 'foobar';
      var autocompleteCallback = jasmine.createSpy('autocompleteCallback');
      spyOn(YammerApi.autocomplete, 'successCallback').andReturn(autocompleteCallback);
      YammerApi.autocomplete.get(term);
      expect(yam.request).toHaveBeenCalledWith({
        url: '/api/v1/autocomplete/ranked',
        method: 'GET',
        data: {'prefix':term,'models' :'user:3,group:2'},
        success: autocompleteCallback
      });
    });
  });

  describe('.successCallback', function(){
    it('returns a function that passes user info to a provided function', function(){
      var autocompleteCallback = jasmine.createSpy('autocompleteCallback');
      var yammerData = {
        'user': [
          {
            'id':'1',
            'full_name':'Henry Smith',
            'photo':'https://c64.assets-yammer.com/images/no_photo_small.gif',
            'messages':'14',
            'followers':'5',
            'ranking':1.0,
            'name':'henry',
            'job_title':'designer'
          },
          {
            'id':'2',
            'full_name':'Bob Jones',
            'messages':'14',
            'followers':'5',
            'photo':'https://c64.assets-yammer.com/images/no_photo_small.gif',
            'ranking':2.0,
            'job_title':'developer'
          }
        ]
      };

      var result = YammerApi.autocomplete.successCallback(autocompleteCallback)(yammerData);
      expect(autocompleteCallback)
        .toHaveBeenCalledWith(
          [
            {
              label: 'Bob Jones',
              photo: "https://c64.assets-yammer.com/images/no_photo_small.gif",
              value: 'Bob Jones',
              jobTitle: 'developer',
              yammerUserId: '2' ,
              ranking: 2.0
            },
            {
              label: 'Henry Smith',
              photo: "https://c64.assets-yammer.com/images/no_photo_small.gif",
              value: 'Henry Smith',
              jobTitle: 'designer',
              yammerUserId: '1',
              ranking: 1.0
            },
          ]
        );
    });
  });
});
