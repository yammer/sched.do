require('/assets/scheddo/models/user.js');
require('/assets/scheddo/models/group.js');
require('/assets/scheddo/translators.js');
require('/assets/underscore.js');

describe('scheddo.translators.autocomplete', function(){
  describe('translateUsers', function(){
    it('translates an array of Yammer users JSON to autocomplete users', function(){
      var users = [{
        full_name: 'test user',
      }];

      var translatedUsers = scheddo.translators.autocomplete.translateUsers(users);

      expect(translatedUsers[0].label).toBe('test user');
      expect(translatedUsers[0].value).toBe('test user');
      expect(translatedUsers[0].type).toBe('user');
      expect(typeof translatedUsers[0].submit).toBe('function');
      expect(typeof translatedUsers[0].render).toBe('function');
    });

    it('reverses the order of the users', function(){
      var users = [{
        full_name: 'test user 1',
      },
      {
        full_name: 'test user 2',
      }];

      var translatedUsers = scheddo.translators.autocomplete.translateUsers(users);

      expect(translatedUsers[0].fullName).toBe('test user 2');
      expect(translatedUsers[1].fullName).toBe('test user 1');
    });
  });

  describe('translateGroups', function(){
    it('translates an array of Yammer groups JSON to autocomplete groups', function(){
      var groups = [{
        full_name: 'test group',
      }];

      var translatedGroups = scheddo.translators.autocomplete.translateGroups(groups);

      expect(translatedGroups[0].label).toBe('test group');
      expect(translatedGroups[0].value).toBe('test group');
      expect(translatedGroups[0].type).toBe('group');
      expect(typeof translatedGroups[0].submit).toBe('function');
      expect(typeof translatedGroups[0].render).toBe('function');
    });

    it('reverses the order of the users', function(){
      var groups = [{
        full_name: 'test group 1',
      },
      {
        full_name: 'test group 2',
      }];

      var translatedGroups = scheddo.translators.autocomplete.translateGroups(groups);

      expect(translatedGroups[0].fullName).toBe('test group 2');
      expect(translatedGroups[1].fullName).toBe('test group 1');
    });
  });

  describe('translateEmail', function(){
    it('translates the input the user has entered into an autocomplete email object', function(){
      var translatedEmail = scheddo.translators.autocomplete.translateEmail('email@user.com');

      expect(translatedEmail.label).toBe('email@user.com');
      expect(translatedEmail.value).toBe('email@user.com');
      expect(translatedEmail.type).toBe('email');
      expect(typeof translatedEmail.submit).toBe('function');
      expect(typeof translatedEmail.render).toBe('function');
    });
  });
});
