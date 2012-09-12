window.parseTime= (time) ->
  d = new Date()
  time_parts = time.match(/(\d+)(?::(\d\d))?\s*([ap]m)?/)
  if !time_parts
    return time
  hours = parseInt(time_parts[1])
  if(hours > 12)
    am_or_pm = "pm"
    hours = hours - 12
  else
    am_or_pm = time_parts[3] or "am"

  minutes = parseInt(time_parts[2]) || 0
  minutes = ("0" + minutes).slice(-2)
  "#{hours}:#{minutes}#{am_or_pm}"
$ ->
  $(".times input").blur ->
    if(!$(this).data("time-parsed"))
      $(this).val(parseTime($(this).val()))
    $(this).data("time-parsed", true)
