Feature: Guest is converted to User

  Scenario: User invites an existing sched.do User by email address
    Given I sign in and create an event named "Clown party"
    And a user exists with a name of "Bruce Wayne" and email of "batman@example.com"
    When I invite "batman@example.com" to "Clown party"
    Then I should see "Bruce Wayne" in the list of invitees
    And "Bruce Wayne" should receive 1 private message

  Scenario: User invites an existing Yammer user with no sched.do account
    Given I sign in and create an event named "Clown party"
    And a Yammer user exists named "Bruce Campell" with email "bruce@example.com"
    And no sched.do user exists with email "bruce@example.com"
    When I invite "bruce@example.com" to "Clown party"
    Then I should see "Bruce Campell" in the list of invitees

  Scenario: Guest invited, then subsequently signs up for Yammer
    Given I sign in and create an event named "Clown party"
    And no Yammer user exists with email "frank@example.com"
    And I invite "frank@example.com" to "Clown party"
    And "frank@example.com" signs up for Yammer as "Frank Castle"
    And I sign out
    And I am signed in as "frank@example.com"
    And I sign in as a different user
    And I visit the event page for "Clown party"
    Then I should see "Frank Castle" in the list of invitees
    And I should not see "frank@example.com"
