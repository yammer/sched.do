Namespaced.declare('Scheddo.Models');

Scheddo.Models.group = function(groupObject){
  return {
    fullName: groupObject.full_name,
    photo: groupObject.photo,
    id: groupObject.id,
    ranking: groupObject.ranking,
  };
};
