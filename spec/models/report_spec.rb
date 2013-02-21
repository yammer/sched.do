require 'spec_helper'

class DummyReport
  include Report

  def initialize(uri, date_format)
    @uri = uri
    @date_format = date_format
  end
end

describe '#get_data_clip' do
  it 'request the json representation of a Heroku dataclip' do
    dummy_report = DummyReport.new(
      'https://www.heroku.com/dataclip', '"\k<day> \k<month> \k<year>"'
    )

    return_value = dummy_report.get_data_clip

    expect(return_value).to eq '{"fields":[["date", "Month"],["number", "Count"]],"values":[["01 07 2012",1]]}'
  end
end

describe '#sanitize_input_data' do
  it 'formats response json' do
    json = '{"fields":["month","count"],"values":[["2012-07-01 00:00:00","1"]]}'

    DummyReport.new(
      'https://www.heroku.com/dataclip', '"\k<day> \k<month> \k<year>"'
    ).sanitize_input_data(json)

    expect(json).to eq '{"fields":["month","count"],"values":[["01 07 2012",1]]}'
  end
end

describe '#get_columns' do
  it 'translates the json response fields to google column declarations' do
    json = '{"fields":["month_date","user_count_number"],"values":[["2012-07-01 00:00:00","1"]]}'

    return_value = DummyReport.new(
      'https://www.heroku.com/dataclip', '"\k<day> \k<month> \k<year>"'
    ).get_columns(json)

    expect(return_value).to eq '{"fields":[["date", "Month"],["number", "User Count"]],"values":[["2012-07-01 00:00:00","1"]]}'
  end
end
