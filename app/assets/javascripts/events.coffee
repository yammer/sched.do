window.parseTime= (time) ->
  d = new Date()
  time_parts = time.match(/(\d+)(?::(\d\d))?\s*([ap]m)?/)
  if !time_parts or time_parts[1] > 24
    return time
  hours = parseInt(time_parts[1])

  if(12 < hours < 24)
    am_or_pm = "pm"
    hours = hours - 12
  else if(0 < hours < 7 or hours is 12)
    am_or_pm = "pm"
  else if(hours is 24 or hours is 0)
    am_or_pm = "am"
    hours = 12
  else
    am_or_pm = time_parts[3] or "am"

  minutes = parseInt(time_parts[2]) or 0
  minutes = ("0" + minutes).slice(-2)
  "#{hours}:#{minutes}#{am_or_pm}"
$ ->
  $(".suggestions").delegate ".times input", "blur", ->
    if(!$(this).data("time-parsed") and $(this).val() != "")
      $(this).val(parseTime($(this).val()))
    $(this).data("time-parsed", true)
