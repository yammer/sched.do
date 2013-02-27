//=require jquery.welcome
//=require waypoints

describe ('accept terms of service', function(){
  it ('shows a flash message if the user does not accept the tos', function(){
    loadFixtures('welcome.html');
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
    loadFixtures('welcome.html');
    event = jQuery.Event('click');
    eventSpy = spyOn(event, 'preventDefault');

    window.require_tos_acceptance(event);

    expect($('.flash').html()).toEqual('');
    expect(eventSpy).not.toHaveBeenCalled();
  });
});
