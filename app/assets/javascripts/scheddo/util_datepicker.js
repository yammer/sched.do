Namespaced.declare('Scheddo.Util');

_.extend(Scheddo.Util, (function() {
  var nextDate = null;

  return {
    setDatepickerDefaultDates: function() {
      $('.primary-suggestion').
        datepicker('option', 'defaultDate', nextDate);
    },

    datepicker: function() {
      var self = this;
      // Displays a date picker when suggetsion field is focused
      $('.primary-suggestion').datepicker({
        nextText: '▶',
        prevText: '◀',
        dateFormat: 'D, M dd yy',
        constrainInput: false,
        onSelect: function(date) {
          nextDate = new Date(date);
          nextDate.setDate(nextDate.getDate() + 1);
          self.setDatepickerDefaultDates();
        }
      });
    },

    setDefaultDate: function(datepicker) {
      if(nextDate) {
        setDatepickerDefaultDates();
      }
    }
  }
})());
