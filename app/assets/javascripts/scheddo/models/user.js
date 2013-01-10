Namespaced.declare('Scheddo.Models');

Scheddo.Models.user = function(userObject){
  return {
    fullName: userObject.full_name,
    photo: userObject.photo || userObject.mugshot_url,
    id: userObject.id,
    ranking: userObject.ranking,
    jobTitle: userObject.job_title,
  };
};
