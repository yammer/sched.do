Feature: User can invite people to an event

  Scenario: User invites a guest
    Given I sign in and create an event named "Clown party"
    When I invite "batman@example.com" to "Clown party"
    Then I should see "batman@example.com" in the list of invitees
    And "batman@example.com" should receive an email
