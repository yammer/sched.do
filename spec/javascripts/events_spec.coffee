require "/assets/jquery.js"
require "/assets/events.coffee"
require "/assets/underscore.js"

describe "window.parse_time", ->
  times =
    "1": "1:00am"
    "1:30": "1:30am"
    "13:30": "1:30pm"
    "1pm": "1:00pm"
    "14:46" : "2:46pm"
    "one": "one"

  it "parses times correctly", ->
    for time, parsedTime of times
        expect(parseTime(time)).toEqual parsedTime
