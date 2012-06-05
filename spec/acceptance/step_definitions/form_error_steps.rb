step 'I should see the error :error_text on the :field_name field' do |error_text, field_name|
  expect_error_on_field_with_name(error_text, field_name)
end

step 'I should see the error :error_text on the field with a data-role of :data_role' do |error_text, data_role|
  expect_error_on_field_with_data_role(error_text, data_role)
end
