step 'a :factory_name exists with a(n) :attribute_name of :value' do |factory_name, attribute_name, value|
  create(factory_name, attribute_name => value)
end

step 'a :factory_name exists with a(n) :attribute_name_1 of :value_1 and :attribute_name_2 of :value_2' do |factory_name, attribute_name_1, value_1, attribute_name_2, value_2|
  create(factory_name, attribute_name_1 => value_1, attribute_name_2 => value_2)
end
