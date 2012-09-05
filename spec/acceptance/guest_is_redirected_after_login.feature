Feature: Guest is redirected to the correct event after login

  Scenario: Guest is not shown name and email fields if coming from yammer.com
    Given someone created an event named "Clown party"
    When I view the login form for the "Clown party" event
    And I click "Sign in with Yammer"
    Then I should be on the "Clown party" event page
