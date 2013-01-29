Feature: Multiple invitations

  @javascript
  Scenario: Owner adds a Yammer user to the invitee list
    Given I sign in and create an event named "Clown party"
    And a user exists with a name of "Joe Smith"
    When I invite the Yammer user "Joe Smith" to "Clown party" from the multiple invite page
    Then I should see "Joe Smith" in the list of invitees

  @javascript
  Scenario: Owner adds a Yammer group to the invitee list
    Given I sign in and create an event named "Clown party"
    When I invite the Yammer group "Scheddo-Devs" to "Clown party" from the multiple invite page
    Then I should see "Scheddo-Devs" in the groups list

  @javascript
  Scenario: Owner adds a user to the invitee list by email
    Given I sign in and create an event named "Clown party"
    When I invite "batman@hotmail.com" to "Clown party" via the autocomplete from the multiple invite page
    Then I should see "batman@hotmail.com" in the list of invitees

  @javascript
  Scenario: Owner adds a Yammer user to the invite list and invites the users
    Given I sign in and create an event named "Clown party"
    And a user exists with a name of "Joe Smith"
    When I invite the Yammer user "Joe Smith" to "Clown party" from the multiple invite page
    And I press "Invite"
    Then "Joe Smith" should receive 1 private message
    And I should not see "Invite someone to your poll, search for them by name or email."

  @javascript
  Scenario: Owner add a Yammer group to the invite list and invites the group
    Given I sign in and create an event named "sched.do Meeting"
    When I invite the Yammer group "Scheddo-Devs" to "sched.do Meeting" from the multiple invite page
    And I press "Invite"
    Then group "Scheddo-Devs" should receive a private invitation message
    And the private invitation message should be sent regarding "sched.do Meeting"

  @javascript
  Scenario: Owner adds a user by email to the invite list and invites the user
    Given I sign in and create an event named "Clown party"
    When I invite "batman@hotmail.com" to "Clown party" via the autocomplete from the multiple invite page
    And I press "Invite"
    Then "batman@hotmail.com" should receive an email
    And I should not see "Invite someone to your poll, search for them by name or email."

  @javascript
  Scenario: Owner adds a Yammer user, Yammer group and email to the invite list and invites them
    Given I sign in and create an event named "Clown party"
    And a user exists with a name of "Joe Smith"
    And I invite the Yammer user "Joe Smith" to "Clown party" from the multiple invite page
    And I invite the Yammer group "Scheddo-Devs" to "Clown party" from the multiple invite page
    And I invite "batman@hotmail.com" to "Clown party" via the autocomplete from the multiple invite page
    When I press the "Invite" button for the "Clown party" event
    Then I should see "Joe Smith" in the list of invitees
    And I should see "batman@hotmail.com" in the list of invitees
    And I should see "Scheddo-Devs" in the groups list

  @javascript
  Scenario: Owner adds a Yammer user to the invite list and then removes the user
    Given I sign in and create an event named "Clown party"
    And a user exists with a name of "Joe Smith"
    And I invite the Yammer user "Joe Smith" to "Clown party" from the multiple invite page
    And I remove "Joe Smith" from the list of invited users
    When I press the "Invite" button for the "Clown party" event
    Then "Joe Smith" should receive 0 private message
    And I should not see "Joe Smith" in the list of invitees

  @javascript
  Scenario: Owner adds a Yammer group to the invite list and then removes the group
    Given I sign in and create an event named "Clown party"
    When I invite the Yammer group "Scheddo-Devs" to "Clown party" from the multiple invite page
    And I remove "Scheddo-Devs" from the list of invited users
    When I press the "Invite" button for the "Clown party" event
    Then I should not see "Scheddo-Devs" in the groups list
    And group "Scheddo-Devs" should not receive a private invitation message

  @javascript
  Scenario: Owner adds an email to the invite list and then removes the email
    Given I sign in and create an event named "Clown party"
    When I invite "batman@hotmail.com" to "Clown party" via the autocomplete from the multiple invite page
    And I remove "batman@hotmail.com" from the list of invited users
    When I press the "Invite" button for the "Clown party" event
    Then I should not see "batman@hotmail.com" in the list of invitees
    And "batman@hotmail.com" should not receive an email

  @javascript
  Scenario: Owner tries to add a user to the invite list with an invalid email
    Given I sign in and create an event named "Clown party"
    When I invite "ba33nmail.com" to "Clown party" via the autocomplete from the multiple invite page
    Then I should see "Invitee email is not an email, Invitee is invalid"

  @javascript
  Scenario: Owner adds invites to the invite list, presses back and then returns to the invite list
    Given I sign in and create an event named "Clown party"
    And a user exists with a name of "Joe Smith"
    And I invite the Yammer user "Joe Smith" to "Clown party" from the multiple invite page
    And I invite the Yammer group "Scheddo-Devs" to "Clown party" from the multiple invite page
    And I invite "batman@hotmail.com" to "Clown party" via the autocomplete from the multiple invite page
    When I click "Back"
    And I press the "Update event" button for the "Clown party" event
    Then I should see "Joe Smith"
    And I should see "batman@hotmail.com"
    And I should see "Scheddo-Devs"
