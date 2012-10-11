class YammerUserIdFinder
  SEARCH_PATH = 'api/v1/users/by_email.json'

  def initialize(user, email)
    @user = user
    @query = { email: URI.escape(email), access_token: user.access_token }.to_query
  end

  def find
    get_user_by_email
    get_id_from_json
  end

  private

  def api_endpoint
    "#{@user.yammer_endpoint}#{SEARCH_PATH}?#{@query}"
  end

  def get_id_from_json
    if @response.present? && parsed_json.present?
      parsed_json['id']
    end
  end

  def get_user_by_email
    @response = RestClient.get(api_endpoint)
  end

  def parsed_json
    JSON.parse(@response)[0]
  end
end
