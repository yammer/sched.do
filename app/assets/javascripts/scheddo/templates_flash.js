Namespaced.declare('Scheddo.Templates');

_.extend(Scheddo.Templates, {
  getShareSuccessTemplate: function(params) {
    Scheddo.Util.configureUnderscore();
    return $.trim(_.template($('#shareFlash').html(), params));
  }
});
