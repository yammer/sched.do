step 'the open graph image should be :image' do |image|
  find('meta[property="og:image"]')['content'].should == image
end

step 'the open graph description should be present' do
  find('meta[property="og:description"]')['content'].should be_present
end

step 'the open graph title should be :title' do |title|
  find('meta[property="og:title"]')['content'].should == title
end
