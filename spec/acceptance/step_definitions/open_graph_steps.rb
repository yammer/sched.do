step 'the OpenGraph image should contain :image' do |image|
  expect(find('meta[property="og:image"]')['content']).to include(image)
end

step 'there is an OpenGraph description' do
  expect(find('meta[property="og:description"]')['content']).to be_present
end

step 'the OpenGraph title should be :title' do |title|
  expect(find('meta[property="og:title"]')['content']).to eq title
end
