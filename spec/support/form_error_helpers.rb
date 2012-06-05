module FormErrorHelpers
  def expect_error_on_field_with_data_role(error_message, data_role)
    field = find_field_by_data_role(data_role)
    expect_error_on_field(error_message, field)
  end

  def expect_error_on_field_with_name(error_message, field_name)
    field = find_field_by_name(field_name)
    expect_error_on_field(error_message, field)
  end

  private

  def expect_error_on_field(error_message, field)
    surrounding_li = find("##{field[:id]}_input")
    errors = surrounding_li.find('.inline-errors').text
    errors.should include error_message
  end
end

RSpec.configure do |c|
  c.include FormErrorHelpers
end
