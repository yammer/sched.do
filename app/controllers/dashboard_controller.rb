class DashboardController < ApplicationController
  before_filter :redirect_non_admin

  def show
  end

  def active_users
    setup_weekly_and_monthly(
      'https://dataclips.heroku.com/xwlzdingltrtobixdsdlwagmjtuj',
      'https://dataclips.heroku.com/eyisfmhtoggpmnilhsparaqlzhqy'
    )
  end

  def polls_created
    setup_weekly_and_monthly(
       'https://dataclips.heroku.com/kjdmxshsgsfkhzzyzocjvdakznnx',
       'https://dataclips.heroku.com/nifshcmevpdrnbepytkfmnhjbaou'
    )
  end

  def users_invited
    setup_weekly_and_monthly(
      'https://dataclips.heroku.com/hmumeukgofkqwzbzpaydutcnbazl',
      'https://dataclips.heroku.com/gkimeinjzsqngrunjhjdgyjrpsrs'
    )
  end

  def invitee_conversion
    setup_weekly(
      'https://dataclips.heroku.com/rsqhikhvkgrhhlbcitzcvxukmucu'
    )
  end

  private

  def setup_weekly_and_monthly(weekly, monthly)
    setup_weekly(weekly)
    setup_monthly(monthly)
  end

  def setup_weekly(uri)
    @weekly_uri = uri
    @weekly = get_data_clip(WeeklyReport, uri)
  end

  def setup_monthly(uri)
    @monthly_uri = uri
    @monthly = get_data_clip(MonthlyReport, uri)
  end

  def get_data_clip(report_type, uri)
    report_type.new(uri).get_data_clip
  end
end
