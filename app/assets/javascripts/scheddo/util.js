var scheddo = scheddo || {};
scheddo.util = scheddo.util || {};

scheddo.util.dataRoleUpdater = function (id, target, dataRole){
  var dataRoleString = '[data-role="' + dataRole + '"]';
  var $field = $(target).closest('fieldset.inputs').find(dataRoleString);
  $field.prop('value', id);
};
