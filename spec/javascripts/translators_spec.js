describe('Scheddo.Translators', function(){
  describe('translateUsers', function(){
    it('translates a Yammer user JSON to an autocomplete user', function(){
      var user = {
        full_name: 'test user',
      };

      var translatedUser = Scheddo.Translators.translateUser(user);

      expect(translatedUser.label).toBe('test user');
      expect(translatedUser.value).toBe('test user');
      expect(translatedUser.type).toBe('user');
      expect(typeof translatedUser.render).toBe('function');
    });
  });

  describe('translateGroups', function(){
    it('translates a Yammer group JSON to autocomplete group', function(){
      var group = {
        full_name: 'test group',
      };

      var translatedGroup = Scheddo.Translators.translateGroup(group);

      expect(translatedGroup.label).toBe('test group');
      expect(translatedGroup.value).toBe('test group');
      expect(translatedGroup.type).toBe('group');
      expect(typeof translatedGroup.render).toBe('function');
    });
  });

  describe('translateEmail', function(){
    it('translates the input the user has entered into an autocomplete email object', function(){
      var translatedEmail = Scheddo.
        Translators.
        translateEmail('email@user.com');

      expect(translatedEmail.label).toBe('email@user.com');
      expect(translatedEmail.value).toBe('email@user.com');
      expect(translatedEmail.type).toBe('email');
      expect(typeof translatedEmail.render).toBe('function');
    });

    it('escapes the label and values to avoid xss', function(){
      var translatedEmail = Scheddo.
        Translators.
        translateEmail('<');

      expect(translatedEmail.label).toBe('&lt;');
      expect(translatedEmail.value).toBe('&lt;');
    });
  });
});
