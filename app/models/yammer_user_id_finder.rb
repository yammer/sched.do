class YammerUserIdFinder
  SEARCH_URL = 'https://www.yammer.com/api/v1/users/by_email.json'

  def initialize(access_token, email)
    @query = { email: URI.escape(email), access_token: access_token }.to_query
  end

  def find
    get_user_by_email
    get_id_from_json
  end

  private

  def get_id_from_json
    if @response.present? && parsed_json.present?
      parsed_json['id']
    end
  end

  def get_user_by_email
    @response = RestClient.get("#{SEARCH_URL}?#{@query}")
  end

  def parsed_json
    JSON.parse(@response)[0]
  end
end
