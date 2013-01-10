Namespaced.declare('Scheddo.Util');

_.extend(Scheddo.Util, {
  isOGObject: function (){
    return $("[property='og:url']").length
  },

  dataRoleUpdater: function (id, target, dataRole){
    var dataRoleString = '[data-role="' + dataRole + '"]';
    var $field = $(target).closest('fieldset.inputs').find(dataRoleString);
    $field.prop('value', id);
  },

  setFlash: function(div, flash){
    $('.flash').html(
      Scheddo.Templates.getShareSuccessTemplate({
        divId: div,
        flashMessage: flash
      })
    );
  },

  configureUnderscore: function(){
    _.templateSettings = {
      interpolate: /\{\{\=(.+?)\}\}/g,
      evaluate: /\{\{(.+?)\}\}/g
    };
  }
});
