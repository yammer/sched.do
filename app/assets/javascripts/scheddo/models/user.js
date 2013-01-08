var scheddo = scheddo || {};
scheddo.models = scheddo.models || {};

scheddo.models.user = function(userObject){
  return {
    fullName: userObject.full_name,
    photo: userObject.photo,
    id: userObject.id,
    ranking: userObject.ranking,
    jobTitle: userObject.job_title,
  };
};
