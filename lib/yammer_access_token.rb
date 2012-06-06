# For some reason, OmniAuth::Strategies::OAuth2#build_access_token returns an
# OAuth2::AccessToken with a #token method that returns a weirdly-parsed string
# of Rubyish JSON ("nil" instead of "null", "=>" instead of ":"). This class
# parses out the actual access token string.
class YammerAccessToken
  def initialize(token_string)
    @token_string = token_string
  end

  def real_token
    json_hash['token']
  end

  private

  def json_hash
    JSON.parse(json)
  end

  def json
    @token_string.gsub('"=>nil', '"=>null').gsub('"=>', '":')
  end
end
