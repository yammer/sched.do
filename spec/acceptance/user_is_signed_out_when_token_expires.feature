Feature: User sessions are expired if their tokens are stale

  Scenario: User creates an event with an expired token and is signed out
    Given I am signed in with an old token
    When I create an event named "Clown party" with a suggestion of "lunch"
    Then I should be signed out
