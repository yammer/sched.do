step "I fill in :field with :value" do |field, value|
  fill_in field, with: value
end

step 'I press :button' do |button|
  click_button button
end

step 'I should see the error :error_text on the :field_name field' do |error_text, field_name|
  begin
    field = find_field(field_name)
  rescue Capybara::ElementNotFound => err
    raise err.class, %{Cannot find field with name "#{field_name}"}
  end
  surrounding_li = find("##{field[:id]}_input")
  errors = surrounding_li.find('.inline-errors').text
  errors.should include error_text
end
