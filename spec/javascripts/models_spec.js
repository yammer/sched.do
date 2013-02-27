describe('Scheddo.Models', function(){
  describe('user', function(){
    it('translates a Yammer JSON user to a scheddo user', function(){
      var jsonUser = {
        full_name: 'test user',
        photo: 'http://photos',
        id: 5,
        ranking: 4,
        job_title: 'engineer'
      };

      var user = Scheddo.Models.user(jsonUser);

      expect(user.fullName).toBe('test user');
      expect(user.photo).toBe('http://photos');
      expect(user.id).toBe(5);
      expect(user.ranking).toBe(4);
      expect(user.jobTitle).toBe('engineer');
    });
  });

  describe('group', function(){
    it('translates a Yammer JSON group to a scheddo group', function(){
      var jsonGroup = {
        full_name: 'test group',
        photo: 'http://photos',
        id: 5,
        ranking: 4,
      };

      var group = Scheddo.Models.user(jsonGroup);

      expect(group.fullName).toBe('test group');
      expect(group.photo).toBe('http://photos');
      expect(group.id).toBe(5);
      expect(group.ranking).toBe(4);
    });
  });
});
