Feature: Invited Yammer Users can invite others to an event

  @javascript
  Scenario: User invites another Yammer User
    Given someone created an event named "Clown party"
    And I am signed in as "Bruce Lee" and I view the page for "Clown party"
    And a user exists with a name of "John Wall" and yammer_network_id of "1"
    When I invite the Yammer user "John Wall" to "Clown party"
    Then I should see "John Wall" in the list of invitees
    And "John Wall" should receive 1 private message

  Scenario: User invites a guest
    Given someone created an event named "Clown party"
    And I am signed in as "Bruce Lee" and I view the page for "Clown party"
    When I invite "batman@example.com" to "Clown party"
    Then "batman@example.com" should receive an invitation email with a link to "Clown party"
    Then "batman@example.com" should receive an email that contains an image of "Bruce Lee"

  Scenario: Guest receives reminder after not voting for five days
    Given someone created an event named "Clown party"
    And I am signed in as "Bruce Lee" and I view the page for "Clown party"
    When I invite "batman@example.com" to "Clown party"
    And "batman@example.com" does not act on the invitation for 5 days
    Then "batman@example.com" should receive a reminder email with a link to "Clown party"
    And "batman@example.com" should receive an email that contains an image of "Bruce Lee"
