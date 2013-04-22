Feature: User can view a profile page

  Scenario: User creates an event and views their profile page
    Given I am signed in
    When I create an event named "Clown party"
    And I visit my polls page
    Then I should see "Clown party" in my Events list

  Scenario: User creates event later navigates to it from the profile page
    Given I am signed in
    When I create an event named "Clown party"
    And I visit my polls page
    And I click "Clown party"
    Then I should be on the "Clown party" event page

  Scenario: User clicks on their name to navigate to their profile
    Given I am signed in as "user@example.com"
    When I click "My Events"
    Then I should be on my profile page
