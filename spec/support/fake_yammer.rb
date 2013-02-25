class FakeYammer < Sinatra::Base
  cattr_accessor :activity_endpoint_hits
  cattr_accessor :access_token
  cattr_accessor :group_id
  cattr_accessor :message
  cattr_accessor :messages_endpoint_hits
  cattr_accessor :user_search_by_email_hits
  cattr_accessor :users_endpoint_hits
  cattr_accessor :yammer_email
  cattr_accessor :yammer_user_name

  def self.reset
    self.activity_endpoint_hits = 0
    self.group_id = 0
    self.messages_endpoint_hits = 0
    self.users_endpoint_hits = 0
    self.user_search_by_email_hits = 0
    self.yammer_user_name = 'Ralph Robot'
    self.yammer_email = 'ralph@example.com'
  end

  post '/api/v1/activity' do
    self.activity_endpoint_hits += 1
    202
  end

  post '/api/v1/messages' do
    self.access_token = params[:access_token]
    self.group_id = params[:group_id]
    self.message = params[:body]
    self.messages_endpoint_hits += 1
    202
  end

  get '/api/v1/users/by_email' do
    self.user_search_by_email_hits += 1

    if params[:email] == self.yammer_email
      json_for_user_email_search
    else
      "[ ]"
    end
  end

  get '/api/v1/users/:user_id' do |user_id|
    self.users_endpoint_hits += 1
    json_for_user_id(user_id)
  end

  private

  def json_for_user_email_search
     <<-JSON.strip_heredoc
     [{"id":1488374236,"expertise":null,"mugshot_url":"https://mug0.assets-yammer.com/mugshot/images/48x48/7Xwtpq7zrtTdfmn-Rbs1ZkHCq8JwxBwW","schools":[],"mugshot_url_template":"https://mug0.assets-yammer.com/mugshot/images/{width}x{height}/7Xwtpq7zrtTdfmn-Rbs1ZkHCq8JwxBwW","significant_other":null,"interests":null,"kids_names":null,"admin":"false","location":null,"timezone":"Pacific Time (US \u0026 Canada)","activated_at":"2012/07/12 23:09:00 +0000","hire_date":null,"type":"user","guid":null,"job_title":"Developer","verified_admin":"false","network_id":63286,"contact":{"im":{"username":"","provider":""},"email_addresses":[{"type":"primary","address":"ralph@thoughtbot.com"}],"phone_numbers":[]},"full_name":"#{yammer_user_name}","first_name":"Ralph","network_name":"thoughtbot","summary":null,"state":"active","stats":{"updates":19,"following":1,"followers":1},"network_domains":["thoughtbot.com"],"name":"ralph","web_url":"https://www.yammer.com/thoughtbot.com/users/ralph","department":null,"external_urls":[],"birth_date":"","show_ask_for_photo":false,"last_name":"Robot","can_broadcast":"false","settings":{"xdr_proxy":"https://xdrproxy.yammer.com"},"url":"https://www.yammer.com/api/v1/users/1488374236","previous_companies":[]}]
     JSON
  end

  def json_for_user_id(user_id)
     <<-JSON.strip_heredoc
      {"external_urls":[],"location":null,"network_name":"Thoughtbot","stats":{"following":1,"updates":3,"followers":1},"state":"active","admin":"false","contact":{"phone_numbers":[],"im":{"provider":"","username":""},"email_addresses":[{"type":"primary","address":"#{self.yammer_email}"}]},"type":"user","network_id":1,"last_name":"Fischer","settings":{"xdr_proxy":"https://xdrproxy.yammer.com"},"interests":null,"birth_date":"","significant_other":null,"previous_companies":[],"expertise":null,"mugshot_url":"https://mug0.assets-yammer.com/mugshot/images/48x48/no_photo.png","activated_at":"2012/07/12 23:09:00 +0000","name":"mason","department":null,"hire_date":null,"guid":null,"kids_names":null,"timezone":"Pacific Time (US \u0026 Canada)","first_name":"Mason","schools":[],"url":"https://www.yammer.com/api/v1/users/1488374236","verified_admin":"false","can_broadcast":"false","mugshot_url_template":"https://mug0.assets-yammer.com/mugshot/images/{width}x{height}/no_photo.png","network_domains":["thoughtbot.com"],"id":"#{user_id}","show_ask_for_photo":false,"full_name":"#{self.yammer_user_name}","web_url":"https://www.yammer.com/thoughtbot.com/users/mason","summary":null,"job_title":"Developer"}
    JSON
  end
end

ShamRack.mount(FakeYammer, 'www.yammer.com', 443)
