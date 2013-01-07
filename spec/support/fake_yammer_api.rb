module FakeYammerApi
  class YammerAutoCompleteMock
    def initialize(params)
      @id = params[:id]
      @name = params[:name]
      @return_type = params[:return_type]
    end

    def build_yammer_response_script
      build_script do |script|
        script.concat(mock_yammer_api_autocomplete_get_with_yammer_response)
      end
    end

    def build_no_yammer_response_script
      build_script do |script|
         script.concat(mock_yammer_api_autocomplete_get_without_yammer_response)
      end
    end

    private

    def build_script
      mock_yammer_api_script = mock_yammer_api
      mock_yammer_api_script.concat(mock_yammer_api_autocomplete)
      mock_yammer_api_script.concat(mock_yammer_api_set_access_token)
      yield(mock_yammer_api_script)

      mock_yammer_api_script
    end

    def mock_yammer_api
      "YammerApi = {};"
    end

    def mock_yammer_api_autocomplete
      "YammerApi.autocomplete = {};"
    end

    def mock_yammer_api_autocomplete_get_with_yammer_response
      mock_yammer_api_autocomplete_get("#{mock_user_json}, #{email_type_object}")
    end

    def mock_yammer_api_autocomplete_get_without_yammer_response
      mock_yammer_api_autocomplete_get(email_type_object)
    end

    def mock_yammer_api_autocomplete_get(response_json)
      <<-eos
        YammerApi.autocomplete.get = function(term, response) {
          response([#{response_json}]);
        };
      eos
    end

    def mock_yammer_api_set_access_token
      <<-eos
        YammerApi.setAccessToken = function(access_token) {
          window['access_token'] = access_token;
        };
      eos
    end

    def mock_user_json
      <<-eos
        {
          yammer#{@return_type.capitalize}Id: #{@id},
          label: '#{@name}',
          jobTitle: 'test',
          type: '#{@return_type.downcase}',
          value: 'test',
          photo: 'https://mug0.assets-yammer.com/mugshot/images/48x48/7Xwtpq7zrtTdfmn-Rbs1ZkHCq8JwxBwW',
          ranking: 5
        }
      eos
    end

    def email_type_object
      "{ label: '#{@name}', value: '#{@name}', type:'email' }"
    end
  end

  def mock_out_yammer_api(params)
    mock_data_provider = YammerAutoCompleteMock.new(params)
    page.execute_script(mock_data_provider.build_yammer_response_script)
  end

  def mock_out_yammer_api_without_yammer_response(params)
    mock_data_provider = YammerAutoCompleteMock.new(params)
    page.execute_script(mock_data_provider.build_no_yammer_response_script)
  end

  def fill_in_autocomplete(selector, value)
    page.execute_script %Q{$('#{selector}').val('#{value}').keydown()}
  end

  def choose_autocomplete(selector, text)
    find(selector).should have_content(text)
    page.execute_script("$('.ui-menu-item:contains(\"#{text}\"):first').find('a').trigger('mouseenter').click()")
  end
end

RSpec.configure do |config|
  config.include FakeYammerApi
end
