Feature: Signed-out user is not asked to sign out

  Scenario: Signed-out user does not see sign out button
    Given someone created an event named "Party"
    When I view the "Party" event
    Then I should not see a sign out button
