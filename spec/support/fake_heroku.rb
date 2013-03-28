class FakeHeroku < Sinatra::Base
  get '/:id:format?' do
    '{"fields":["month_string","count_number"],"values":[["2012-07-01 00:00:00","1"]]}'
  end
end

ShamRack.mount(FakeHeroku, 'dataclips.heroku.com', 443)
