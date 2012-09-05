class FakeYammer < Sinatra::Base
  cattr_accessor :activity_endpoint_hits
  cattr_accessor :message
  cattr_accessor :messages_endpoint_hits
  cattr_accessor :users_endpoint_hits
  cattr_accessor :yammer_user_name

  def self.reset
    self.activity_endpoint_hits = 0
    self.messages_endpoint_hits = 0
    self.users_endpoint_hits = 0
    self.yammer_user_name = 'Mason Fischer'
  end

  post '/api/v1/activity.json' do
    self.activity_endpoint_hits += 1
    202
  end

  post '/api/v1/messages.json' do
    self.messages_endpoint_hits += 1
    self.message = params[:body]
    202
  end

  get '/api/v1/users/:user_id.json' do |user_id|
    self.users_endpoint_hits += 1
     <<-JSON.strip_heredoc
      {"external_urls":[],"location":null,"network_name":"Thoughtbot","stats":{"following":1,"updates":3,"followers":1},"state":"active","admin":"false","contact":{"phone_numbers":[],"im":{"provider":"","username":""},"email_addresses":[{"type":"primary","address":"mason@example.com"}]},"type":"user","network_id":1,"last_name":"Fischer","settings":{"xdr_proxy":"https://xdrproxy.yammer.com"},"interests":null,"birth_date":"","significant_other":null,"previous_companies":[],"expertise":null,"mugshot_url":"https://mug0.assets-yammer.com/mugshot/images/48x48/no_photo.png","activated_at":"2012/07/12 23:09:00 +0000","name":"mason","department":null,"hire_date":null,"guid":null,"kids_names":null,"timezone":"Pacific Time (US \u0026 Canada)","first_name":"Mason","schools":[],"url":"https://www.yammer.com/api/v1/users/1488374236","verified_admin":"false","can_broadcast":"false","mugshot_url_template":"https://mug0.assets-yammer.com/mugshot/images/{width}x{height}/no_photo.png","network_domains":["thoughtbot.com"],"id":1488374236,"show_ask_for_photo":false,"full_name":"#{self.yammer_user_name}","web_url":"https://www.yammer.com/thoughtbot.com/users/mason","summary":null,"job_title":"Developer"}
    JSON
  end
end

ShamRack.mount(FakeYammer, 'www.yammer.com', 443)
