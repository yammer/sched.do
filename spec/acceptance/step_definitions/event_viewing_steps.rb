step 'I should see a suggested time of :time' do |time|
  within '.times' do
    page.should have_content time
  end
end
