Feature: User can see create poll button on the show page
  Scenario: User views the event page
    Given someone created an event named "Clown party" with a suggestion of "lunch"
    And "user@example.com" was invited to the event "Clown party"
    And I am signed in as "user@example.com"
    When I view the "Clown party" event
    Then I should see the "Create Poll" link

  Scenario: User views the new event page
    Given I am signed in as "user@example.com"
    When I visit the homepage
    Then I should not see the "Create Poll" link
