Feature: User can invite people to an event

  Scenario: User invites an invalid user
    Given I sign in and create an event named "Clown party"
    When I invite "Unknown User" to "Clown party"
    Then I should see "Invitee is invalid"

  Scenario: User invites a user twice
    Given I sign in and create an event named "Clown party"
    And a user exists with a name of "Joe Smith"
    When I invite the Yammer user "Joe Smith" to "Clown party"
    And I invite the Yammer user "Joe Smith" to "Clown party"
    Then I should see "Invitee has already been invited"

  Scenario: User invites a guest by email address
    Given I sign in and create an event named "Clown party"
    When I invite "batman@example.com" to "Clown party"
    Then I should see "batman@example.com" in the list of invitees
    And "batman@example.com" should receive an email

  Scenario: User invites a Yammer user in-network using their name
    Given I sign in and create an event named "Clown party"
    And a user exists with a name of "Joe Smith" and yammer_network_id of "1"
    When I invite the Yammer user "Joe Smith" to "Clown party"
    Then I should see "Joe Smith" in the list of invitees
    And "Joe Smith" should receive 1 private message

  Scenario: User invites a Yammer user by email address
    Given I sign in and create an event named "Clown party"
    And a user exists with a name of "Bruce Wayne" and email of "batman@example.com"
    When I invite "batman@example.com" to "Clown party"
    Then I should see "Bruce Wayne" in the list of invitees
    And "Bruce Wayne" should receive 1 private message

  Scenario: User invites a Yammer user out-network using their name
    Given I sign in and create an event named "Clown party"
    And a user exists with a name of "Frank Drebin" and yammer_network_id of "2"
    When I invite the Yammer user "Frank Drebin" to "Clown party"
    Then I should see "Frank Drebin" in the list of invitees
    And out-network Yammer user "Frank Drebin" should get an email notification

  Scenario: Guest email is prefilled when invited via email
    Given I sign in and create an event named "Clown party"
    When I invite "batman@example.com" to "Clown party"
    And I sign out
    And "batman@example.com" follows the link "Clown party" in his email
    Then I should see "Email" filled in with "batman@example.com"

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
