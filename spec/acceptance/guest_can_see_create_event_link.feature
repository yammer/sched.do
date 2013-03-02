Feature: Guest can see create event link
  @javascript
  Scenario: Guest can see create event link
    Given someone created an event named "Clown party" with a suggestion of "lunch"
    And "guest@example.com" was invited to the event "Clown party"
    And I am signed in as the guest "guest@example.com"
    When I view the "Clown party" event
    And I click "Create Poll"
    Then I should see the "Sign in with Yammer" button
    When I press "Sign in with Yammer"
    Then I should be redirected to the new event page
