class WeeklyReport
  include Report

  def initialize(uri)
    @uri = uri
    @date_format = '"\k<month>/\k<day>/\k<year>"'
  end
end
