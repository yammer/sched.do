require('/assets/jquery.js');
require('/assets/waypoints.js');
require('/assets/jquery.welcome.js');

require('/assets/jasmine-jquery.js');

describe ('accept terms of service', function(){
  template('welcome.html')

  it ('shows a flash message if the user does not accept the tos', function(){
    $('input[name=agree_to_tos]').attr('checked', false);
    event = jQuery.Event('click');
    eventSpy = spyOn(event, 'preventDefault');

    window.require_tos_acceptance(event);

    var termsOfServicePrompt = '<div id="flash-error">Please agree to the terms of service</div>';

    expect($('.flash').html()).toEqual(termsOfServicePrompt);
    expect(eventSpy).toHaveBeenCalled();
    expect($('input[name=agree_to_tos][type=checkbox]').is(':checked')).toEqual(true);
  });

  it ('does not show a flash message if the user accepts the tos', function(){
    event = jQuery.Event('click');
    eventSpy = spyOn(event, 'preventDefault');

    window.require_tos_acceptance(event);

    expect($('.flash').html()).toEqual('');
    expect(eventSpy).not.toHaveBeenCalled();
  });
});
