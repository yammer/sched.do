step 'I should see a suggestion of :suggestion' do |suggestion|
  within '.suggestions' do
    page.should have_content suggestion
  end
end
