require('/assets/namespaced.js');
require('/assets/modernizr.custom.js');
require('/assets/jquery.js');
require('/assets/jquery.app.js');
require('/assets/jquery-ui.js');

describe ('setNextDatePicker', function(){
  it ('sets the next date picker', function(){
    first_date_picker = $('input[data-role="primary-suggestion"]:first')
    today = new Date()
    tomorrow = new Date()
    tomorrow.setDate(today.getDate()+1)
    datepickerSpy = spyOn($.fn, 'datepicker').andReturn(today)

    Scheddo.setNextDatePicker.call(first_date_picker)

    expect($.fn.datepicker).toHaveBeenCalled()
    nextSelector= 'input[data-role="primary-suggestion"]:first.parent().parent().parent().next() input[data-role="primary-suggestion"]'
    expect(datepickerSpy.mostRecentCall.object.selector).toEqual(nextSelector)
    expect(datepickerSpy.mostRecentCall.args[0]).toEqual("option")
    expect(datepickerSpy.mostRecentCall.args[1]).toEqual("defaultDate")
    expect(datepickerSpy.mostRecentCall.args[2]).toEqual(tomorrow)
  });
});
