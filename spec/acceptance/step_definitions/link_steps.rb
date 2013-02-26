step 'I click :link' do |link|
  click_link link
end

step 'I click image link :image' do |image|
  page.find(:xpath, "//a/img[@alt='#{image}']/..").click
end
