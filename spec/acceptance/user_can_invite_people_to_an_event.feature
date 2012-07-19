Feature: User can invite people to an event

  Scenario: User invites a guest
    Given I sign in and create an event named "Clown party"
    When I invite "batman@example.com" to "Clown party"
    Then I should see "batman@example.com" in the list of invitees
    And "batman@example.com" should receive an email

  Scenario: Guest email is prefilled when invited via email
    Given I sign in and create an event named "Clown party"
    When I invite "batman@example.com" to "Clown party"
    And I sign out
    And "batman@example.com" follows the link "Clown party" in his email
    Then I should see "guest_email" filled in with "batman@example.com"

  Scenario: User invites multiple guests, each guest only receives a single invitation
    Given I sign in and create an event named "Clown party"
    When I invite "batman@example.com" to "Clown party"
    When I invite "spiderman@example.com" to "Clown party"
    Then "batman@example.com" should have 1 email

  Scenario: Invitees are placed in reverse chronological order
    Given I sign in and create an event named "Clown party"
    When I invite "batman@example.com" to "Clown party"
    When I invite "spiderman@example.com" to "Clown party"
    Then "spiderman@example.com" should appear before "batman@example.com"
