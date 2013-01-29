require('/assets/application.js')

describe('Scheddo.Translators.MultiInvite', function(){
  describe('translateUsers', function(){
    it('reverses the order of the users', function(){
      var users = [
        { full_name: 'test user 1' },
        { full_name: 'test user 2' }
      ];

      var translatedUsers = Scheddo.Translators.MultiInvite.translateUsers(users);

      expect(translatedUsers[0].fullName).toBe('test user 2');
      expect(translatedUsers[1].fullName).toBe('test user 1');
    });
  });

  describe('translateGroups', function(){
    it('reverses the order of the users', function(){
      var groups = [
        { full_name: 'test group 1' },
        { full_name: 'test group 2' }
      ];

      var translatedGroups = Scheddo.Translators.MultiInvite.translateGroups(groups);

      expect(translatedGroups[0].fullName).toBe('test group 2');
      expect(translatedGroups[1].fullName).toBe('test group 1');
    });
  });

  describe('translateEmail', function(){
    it('translates the input the user has entered into an autocomplete email object', function(){
      var translatedEmail = Scheddo.Translators.MultiInvite.translateEmail('email@user.com');

      expect(typeof translatedEmail.submit).toBe('function');
      expect(typeof translatedEmail.post).toBe('function');
    });
  });

  describe('addMethodsToUser', function(){
    it('translates a Yammer user JSON to an autocompletePost user', function(){
      var users = { full_name: 'test user' };

      var translatedUser = Scheddo.
        Translators.
        MultiInvite.
        addMethodsToUser(users);

      expect(typeof translatedUser.submit).toBe('function');
      expect(typeof translatedUser.post).toBe('function');
    });
  });

  describe('addMethodsToGroup', function(){
    it('translates a Yammer group JSON to an autocomplete group', function(){
      var group = { full_name: 'test group' };

      var translatedGroup = Scheddo.
        Translators.
        MultiInvite.
        addMethodsToGroup(group);

      expect(typeof translatedGroup.submit).toBe('function');
      expect(typeof translatedGroup.post).toBe('function');
    });
  });

  describe('addMethodsToEmail', function(){
    it('translates the input the user has entered into an autocomplete email object', function(){
      var translatedEmail = Scheddo.
        Translators.
        MultiInvite.
        addMethodsToEmail({});

      expect(typeof translatedEmail.submit).toBe('function');
      expect(typeof translatedEmail.post).toBe('function');
    });
  });
});
