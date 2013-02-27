describe('Scheddo.Translators.SingleInvite', function(){
  describe('translateUsers', function(){
    it('translates an array of Yammer user JSON to an array of autocompletePost users', function(){
      var users = [
        { full_name: 'test user' }
      ];

      var translatedUsers = Scheddo.
        Translators.
        SingleInvite.
        translateUsers(users);

      expect(typeof translatedUsers[0].submit).toBe('function');
    });

    it('reverses the order of the users', function(){
      var users = [
        { full_name: 'test user 1' },
        { full_name: 'test user 2' }
      ];

      var translatedUsers = Scheddo.
        Translators.
        SingleInvite.
        translateUsers(users);

      expect(translatedUsers[0].fullName).toBe('test user 2');
      expect(translatedUsers[1].fullName).toBe('test user 1');
    });
  });

  describe('translateGroups', function(){
    it('translates an array of Yammer group JSON to an array of autocomplete groups', function(){
      var group = { full_name: 'test group' };

      var translatedGroups = Scheddo.
        Translators.
        SingleInvite.
        translateGroups(group);

      expect(typeof translatedGroups[0].submit).toBe('function');
    });

    it('reverses the order of the users', function(){
      var groups = [
        { full_name: 'test group 1' },
        { full_name: 'test group 2' }
      ];

      var translatedGroups = Scheddo.
        Translators.
        SingleInvite.
        translateGroups(groups);

      expect(translatedGroups[0].fullName).toBe('test group 2');
      expect(translatedGroups[1].fullName).toBe('test group 1');
    });
  });

  describe('translateEmail', function(){
    it('translates the input the user has entered into an autocomplete email object', function(){
      var translatedEmail = Scheddo.
        Translators.
        SingleInvite.
        translateEmail('email@user.com');

      expect(typeof translatedEmail.submit).toBe('function');
    });
  });
});
