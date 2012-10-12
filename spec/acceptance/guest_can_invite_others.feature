Feature: Guest invitees can invite others to an event

  Scenario: Guest invites another guest via email
    Given someone created an event named "Clown party"
    And "guest@example.com" was invited to the event "Clown party"
    And I am signed in as the guest "guest@example.com"
    When I view the "Clown party" event
    And I invite "dangermouse@example.com" to "Clown party"
    Then I should see "dangermouse@example.com" in the list of invitees
    And "dangermouse@example.com" should receive an email

  Scenario: Guest should not access autocomplete when inviting others
    Given someone created an event named "Clown party"
    And "guest@example.com" was invited to the event "Clown party"
    And I am signed in as the guest "guest@example.com"
    And I view the "Clown party" event
    And I fill in "Joe Smith" in the invitation field
    Then I should see "Invitee is invalid"
    And I should not see "Joe Smith" in the list of invitees

  Scenario: Guest invites a user twice
    Given someone created an event named "Clown party"
    And "guest@example.com" was invited to the event "Clown party"
    And I am signed in as the guest "guest@example.com"
    When I view the "Clown party" event
    And I invite "dangermouse@example.com" to "Clown party"
    And I invite "dangermouse@example.com" to "Clown party"
    Then I should see "Invitee has already been invited"

  Scenario: Guest invites an invalid user
    Given someone created an event named "Clown party"
    And "guest@example.com" was invited to the event "Clown party"
    And I am signed in as the guest "guest@example.com"
    And I view the "Clown party" event
    When I invite "Unknown Owner" to "Clown party"
    Then I should see "Invitee is invalid"

  Scenario: Guest invites a Yammer user by email address
    Given someone created an event named "Clown party"
    And "guest@example.com" was invited to the event "Clown party"
    And I am signed in as the guest "guest@example.com"
    And I view the "Clown party" event
    And a user exists with a name of "Bruce Wayne" and email of "batman@example.com"
    When I invite "batman@example.com" to "Clown party"
    Then I should see "Bruce Wayne" in the list of invitees
    And "batman@example.com" should receive an email
