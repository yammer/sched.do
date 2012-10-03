Feature: Invited Yammer Users can invite others to an event

  Scenario: User invites another Yammer User
    Given someone created an event named "Clown party"
    And I am signed in as "Bruce Lee" and I view the page for "Clown party"
    And a user exists with a name of "John Wall" and yammer_network_id of "1"
    When I invite the Yammer user "John Wall" to "Clown party"
    Then I should see "John Wall" in the list of invitees
    And "John Wall" should receive 1 private message
