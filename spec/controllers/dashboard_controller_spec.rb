require 'spec_helper'

describe DashboardController, '#show' do
  it 'serves as a dashboard landing page' do
    user = create(:admin)
    sign_in_as(user)

    get :show

    expect(response).to be_success
  end
end

describe DashboardController, '#active_users' do
  it 'renders the weekly and monthly polls created reports' do
    weekly_monthly_report_spec_helper(
      'https://dataclips.heroku.com/xwlzdingltrtobixdsdlwagmjtuj',
      'https://dataclips.heroku.com/eyisfmhtoggpmnilhsparaqlzhqy',
      :active_users
    )
  end
end

describe DashboardController, '#polls_created' do
  it 'renders the weekly and monthly polls created reports' do
    weekly_monthly_report_spec_helper(
      'https://dataclips.heroku.com/kjdmxshsgsfkhzzyzocjvdakznnx', 
      'https://dataclips.heroku.com/nifshcmevpdrnbepytkfmnhjbaou',
      :polls_created
    )
  end
end

describe DashboardController, '#users_invited' do
  it 'renders the weekly and monthly polls created reports' do
    weekly_monthly_report_spec_helper(
      'https://dataclips.heroku.com/hmumeukgofkqwzbzpaydutcnbazl',
      'https://dataclips.heroku.com/gkimeinjzsqngrunjhjdgyjrpsrs',
      :users_invited
    )
  end
end

describe DashboardController, '#invitee_conversion' do
  it 'renders the weekly and monthly polls created reports' do
    user = create(:admin)
    sign_in_as(user)
    WeeklyReport.
      any_instance.
      stubs(:get_data_clip).
      returns('the weekly data')

    get :invitee_conversion

    expect(assigns(:weekly)).to eq 'the weekly data'
    expect(WeeklyReport.any_instance).to have_received(:get_data_clip)
    expect(assigns(:weekly_uri)).
      to eq 'https://dataclips.heroku.com/rsqhikhvkgrhhlbcitzcvxukmucu'
  end
end

def weekly_monthly_report_spec_helper(weekly, monthly, action)
  user = create(:admin)
  sign_in_as(user)
  WeeklyReport.
    any_instance.
    stubs(:get_data_clip).
    returns('the weekly data')

  MonthlyReport.
    any_instance.
    stubs(:get_data_clip).
    returns('the monthly data')

  get action

  expect(assigns(:weekly)).to eq 'the weekly data'
  expect(assigns(:monthly)).to eq 'the monthly data'
  expect(WeeklyReport.any_instance).to have_received(:get_data_clip)
  expect(MonthlyReport.any_instance).to have_received(:get_data_clip)
  expect(assigns(:weekly_uri)).to eq weekly
  expect(assigns(:monthly_uri)).to eq monthly
end
