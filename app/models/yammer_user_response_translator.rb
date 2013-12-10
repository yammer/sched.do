class YammerUserResponseTranslator
  def initialize(response, user)
    @response = response
    @user = user
  end

  def translate
    @user.yammer_user_id = @response[:id]
    @user.email = parse_email_from_response
    @user.image = @response[:mugshot_url]
    @user.name = @response[:full_name]
    @user.nickname = @response[:name]
    @user.yammer_profile_url = @response[:web_url]
    @user.yammer_network_id = @response[:network_id]
    @user.yammer_network_name = @response[:network_name]
    @user.extra = @response
    @user
  end

  private

  # def parse_email_from_response
  #   if @response && @response[:contact] && @response[:contact][:email_addresses]
  #     primary_email = @response[:contact][:email_addresses].
  #       detect{ |address| address[:type] == 'primary' }
  #     primary_email && primary_email[:address]
  #   end
  # end


  def parse_email_from_response
    if valid_response?
      primary_email && primary_email_address
    end
  end

  def valid_response?
    @response && @response[:contact] && @response[:contact][:email_addresses]
  end

  def primary_email
    all_email_addresses.detect{ |address| address[:type] == 'primary' }
  end

  def all_email_addresses
    @response[:contact][:email_addresses]
  end

  def primary_email_address
    primary_email[:address]
  end
end
