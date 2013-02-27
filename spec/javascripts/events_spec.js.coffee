#= require jquery.js
#= require events.coffee
#= require underscore.js

describe "window.parse_time", ->
  times =
    "0": "12:00am"
    "1": "1:00pm"
    "1pm": "1:00pm"
    "1:30": "1:30pm"
    "3:00": "3:00pm"
    "7": "7:00am"
    "7:30": "7:30am"
    "11": "11:00am"
    "11:59": "11:59am"
    "12": "12:00pm"
    "13:30": "1:30pm"
    "14:46" : "2:46pm"
    "18": "6:00pm"
    "23": "11:00pm"
    "24": "12:00am"
    "38:00": "38:00"
    "one": "one"

  it "parses times correctly", ->
    for time, parsedTime of times
        expect(parseTime(time)).toEqual parsedTime
