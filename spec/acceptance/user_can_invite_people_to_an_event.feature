Feature: User can invite people to an event

  Scenario: User invites a guest
    Given I sign in and create an event named "Clown party"
    When I invite "batman@example.com" to "Clown party"
    Then I should see "batman@example.com" in the list of invitees
    And "batman@example.com" should receive an email

  Scenario: User invites multiple guests, each guest only receives a single invitation
    Given I sign in and create an event named "Clown party"
    When I invite "batman@example.com" to "Clown party"
    When I invite "spiderman@example.com" to "Clown party"
    Then "batman@example.com" should have 1 email

  Scenario: User adds a custom message
    Given I sign in and create an event named 'Clown party'
    When I update the message with the text 'Welcome!'
    And I invite "batman@example.com" to "Clown party"
    Then "batman@example.com" should receive an email with the text 'Welcome!'
