module FakeYammerApi
  class ScheddoYammerMock
    def initialize(params={})
      @id = params[:id]
      @name = params[:name]
      @return_type = params[:return_type]
    end

    def build_script
      mock_yammer_api_script = mock_yammer_api_response

      mock_yammer_api_script
    end

    def build_no_response_script
      mock_yammer_api_script = mock_yammer_api_with_no_response

      mock_yammer_api_script
    end

    def build_failed_response_script
      mock_yammer_api_script = mock_failed_yammer_api_response

      mock_yammer_api_script
    end

    private

    def mock_yammer_api_with_no_response
      mock_yam_request()
    end

    def mock_yammer_api_response
      mock_yam_request(mock_user_json)
    end

    def mock_yam_request(response_json='{ user: [], group: [] }')
      <<-eos
      var request = _.clone(yam.request);
      yam.request = function(options){
        options['success'](#{response_json});
      };

      _.extend(yam.request, request);
      eos
    end

    def mock_failed_yammer_api_response
      <<-eos
        var request = _.clone(yam.request);
        yam.request = function(options){
          options['error']();
        };

        _.extend(yam.request, request);
      eos
    end

    def mock_user_json
      <<-eos
        {
      #{@return_type.downcase}: [{
            id: #{@id},
            full_name: '#{@name}',
            jobTitle: 'test',
            photo: 'https://mug0.assets-yammer.com/mugshot/images/48x48/7Xwtpq7zrtTdfmn-Rbs1ZkHCq8JwxBwW',
            ranking: 5
          }]
        }
      eos
    end
  end

  def mock_out_yammer_api_with_no_response()
    mock_data_provider = ScheddoYammerMock.new()
    page.execute_script(mock_data_provider.build_no_response_script)
  end

  def mock_out_yammer_api(params)
    mock_data_provider = ScheddoYammerMock.new(params)
    page.execute_script(mock_data_provider.build_script)
  end

  def mock_failed_yam_request
    mock_data_provider = ScheddoYammerMock.new()
    page.execute_script(mock_data_provider.build_failed_response_script)
  end


  def fill_in_autocomplete(value, parent='')
    page.execute_script %Q{$('#{parent} #auto-complete').val('#{value}').keydown()}
  end

  def choose_autocomplete(selector, text, parent='')
    find(selector).should have_content(text)
    page.execute_script("$('#{parent} .ui-menu-item:contains(\"#{text}\"):first').find('a').trigger('mouseenter').click()")
  end
end

RSpec.configure do |config|
  config.include FakeYammerApi
end
