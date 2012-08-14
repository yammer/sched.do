Feature: User cannot guess event show link

  Scenario: User visits the show page by uuid
    Given I sign in and create an event named "Clown party"
    And I visit the event show page
    Then I should see "Clown party"


  Scenario: User visits the show page by id
    Given I sign in and create an event named "Clown party"
    Then I should not be able to access it by id

