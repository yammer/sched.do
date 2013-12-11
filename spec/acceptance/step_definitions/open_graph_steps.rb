step 'the OpenGraph image should contain :image' do |image|
  expect(
    find(:css, 'meta[property="og:image"]', visible: false)['content']
  ).to include(image)
end

step 'there is an OpenGraph description' do
  expect(
    find(:css, 'meta[property="og:description"]', visible: false)['content']
  ).to be_present
end

step 'the OpenGraph title should be :title' do |title|
  expect(
    find(:css, 'meta[property="og:title"]', visible: false)['content']
  ).to eq title
end
