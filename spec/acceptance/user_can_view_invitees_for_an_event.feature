Feature: User can view invitees for an event

  Scenario: User views invitees
    Given a user exists with a name of "Joe Smith"
    And I am signed in
    When I create an event named "Party"
    And I invite the Yammer user "Joe Smith" to "Party"
    Then I should see "Joe Smith" in the list of invitees
