class FakeHeroku < Sinatra::Base
  get '/dataclip.json' do
    '{"fields":["month_date","count_number"],"values":[["2012-07-01 00:00:00","1"]]}'
  end
end

ShamRack.mount(FakeHeroku, 'www.heroku.com', 443)
