Feature: Owner can create an event

  Scenario: Owner sees multiple invitation page
    Given I am signed in
    When I create an event named "Clown party" with a suggestion of "lunch"
    Then I should see a page asking me to invite my friends
