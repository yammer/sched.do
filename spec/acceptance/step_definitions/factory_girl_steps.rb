step 'a :factory_name exists with a(n) :attribute_name of :value' do |factory_name, attribute_name, value|
  create(factory_name, attribute_name => value)
end
