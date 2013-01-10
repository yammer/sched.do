//= require jquery.event
//= require yammer_feed
//= require votes

if(Scheddo.YammerApi.isYammerUser()){
  $.widget('custom.yammerAutocomplete',
    $.ui.autocomplete,
      Scheddo.autocompleteConfiguration(Scheddo.Translators.AutocompletePost));

  $("input[data-role='invitation_name']").yammerAutocomplete();
}
