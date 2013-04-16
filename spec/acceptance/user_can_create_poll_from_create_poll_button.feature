Feature: User clicks create poll button and is redirected to the new event page
  Scenario: User clicks the "Create Poll" link
    Given someone created an event named "Clown party" with a suggestion of "lunch"
    And "user@example.com" was invited to the event "Clown party"
    And I am signed in as "user@example.com"
    When I view the "Clown party" event
    And I click "Create Event"
    Then I should not see the "Sign in with Yammer" button
    And I should be redirected to the new event page
