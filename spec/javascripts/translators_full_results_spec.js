require('/assets/application.js');

describe('normalizeTranslatedResponse', function(){
  it('returns a function that translates Yammer data', function(){
    var returnValue = Scheddo.
      Translators.
      FullResults.
      normalizeTranslatedResponse('', function(){ });

    expect(typeof returnValue).toBe('function');
  });

  describe('the function returned by normalizeTranslatedResponse', function(){
    setupTranslator = function(){
      translator = jasmine.createSpyObj('translator',
        ['translateUsers', 'translateGroups', 'translateEmail']);
      translator.translateUsers.andReturn([]);
      translator.translateGroups.andReturn([]);
      translator.translateEmail.andReturn([]);
      _.extend(translator, Scheddo.Translators.FullResults);

      return translator;
    };

    it('transforms user data', function(){
      var translator = setupTranslator();
      var yammerData = {
        'user': [
          {
            data: 'user data'
          }
        ]
      };

      translator.normalizeTranslatedResponse(
        '',
        function(param){ }
      )(yammerData);

      expect(translator.translateUsers).
        toHaveBeenCalledWith(yammerData['user']);
    });

    it('transforms group data', function(){
      var translator = setupTranslator();
      var yammerData = {
        'group': [
          {
            data: 'group data'
          }
        ]
      };

      translator.normalizeTranslatedResponse(
        '', 
        function(param){ }
      )(yammerData);

      expect(translator.translateGroups).
        toHaveBeenCalledWith(yammerData['group']);
    });

    it('transforms email data', function(){
      var translator = setupTranslator();

      translator.normalizeTranslatedResponse(
        'term', 
        function(param){ }
      )({});

      expect(translator.translateEmail).toHaveBeenCalledWith('term');
    });

    it('concatenates the users, groups and email', function(){
      var translator = setupTranslator();
      translator.translateUsers.andReturn(['user']);
      translator.translateGroups.andReturn(['group']);
      translator.translateEmail.andReturn('email');
      var response = jasmine.createSpy(response);

      translator.normalizeTranslatedResponse('term', response)({});

      expect(response).toHaveBeenCalledWith(['user', 'group', 'email']);
    });
  });
});
