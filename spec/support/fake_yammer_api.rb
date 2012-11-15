module FakeYammerApi
  class YammerAutoCompleteMock
    def initialize(params)
      @id = params[:id]
      @name = params[:name]
      @return_type = params[:return_type]
    end

    def build_script
      mock_yammer_api_script = mock_yammer_api
      mock_yammer_api_script += mock_yammer_api_autocomplete
      mock_yammer_api_script += mock_yammer_api_autocomplete_get
      mock_yammer_api_script += mock_yammer_api_set_access_token

      mock_yammer_api_script
    end

    private

    def mock_yammer_api
      "YammerApi = {};"
    end

    def mock_yammer_api_autocomplete
      "YammerApi.autocomplete = {};"
    end

    def mock_yammer_api_autocomplete_get
      <<-eos
        YammerApi.autocomplete.get = function(term, response) {
          response([#{mock_user_json}, #{empty_user_json}]);
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

    def empty_user_json
      "{label:{}, value:{}, type:'email'}"
    end
  end

  def mock_out_yammer_api(params)
    mock_data_provider = YammerAutoCompleteMock.new(params)
    page.execute_script(mock_data_provider.build_script)
  end

  def fill_in_autocomplete(selector, value)
    page.execute_script %Q{$('#{selector}').val('#{value}').keydown()}
  end

  def choose_autocomplete(selector, text)
    find('.name').should have_content(text)
    page.execute_script("$('.ui-menu-item:contains(\"#{text}\")').find('a').trigger('mouseenter').click()")
  end
end

RSpec.configure do |config|
  config.include FakeYammerApi
end
