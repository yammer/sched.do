var scheddo = scheddo || {};
scheddo.models = scheddo.models || {};

scheddo.models.group = function(groupObject){
  return {
    fullName: groupObject.full_name,
    photo: groupObject.photo,
    id: groupObject.id,
    ranking: groupObject.ranking,
  };
};
