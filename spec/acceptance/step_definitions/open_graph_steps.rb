step 'the OpenGraph image should contain :image' do |image|
  find('meta[property="og:image"]')['content'].should include(image)
end

step 'there is an OpenGraph description' do
  find('meta[property="og:description"]')['content'].should be_present
end

step 'the OpenGraph title should be :title' do |title|
  find('meta[property="og:title"]')['content'].should == title
end
