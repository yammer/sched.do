class MonthlyReport
  include Report

  def initialize(uri)
    @uri = uri
    @date_format = '"\k<month>/\k<year>"'
  end
end
