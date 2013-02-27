//=require event_form

describe ('setDatepickerDefaultDates', function() {
  it ('sets the next date picker', function() {
    loadFixtures('event.html');
    Scheddo.Util.datepicker();

    var today = new Date();
    var tomorrow = new Date();
    tomorrow.setDate(today.getDate() + 1);
    var nextDate = tomorrow;

    $('.primary-suggestion').click();
    $('.ui-state-default:contains(' + today.getDate()  + '):first').click();

    var defaultDate = $('.primary-suggestion').datepicker('option', 'defaultDate')
    expect(defaultDate.getYear()).toEqual(tomorrow.getYear());
    expect(defaultDate.getMonth()).toEqual(tomorrow.getMonth());
    expect(defaultDate.getDate()).toEqual(tomorrow.getDate());
  });
});
