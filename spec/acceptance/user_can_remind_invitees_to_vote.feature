Feature: Owner can remind invitees to vote

  @javascript
  Scenario: Owner can remind all invitees to vote
    Given I sign in and create an event named "Clown party"
    And a user exists with a name of "Joe Smith" and yammer_network_id of "1"
    When I invite the Yammer user "Joe Smith" to "Clown party"
    And I invite "batman@example.com" to "Clown party"
    And I click "Remind Them!"
    And I should see "Reminders sent"
    Then I should see "Reminders sent" in the notice flash
    And "batman@example.com" should have 2 emails
    And "Joe Smith" should receive a private reminder message

  @javascript
  Scenario: Owner can remind a specific invitee to vote
    Given I sign in and create an event named "Clown party"
    And a user exists with a name of "Joe Smith"
    When I invite the Yammer user "Joe Smith" to "Clown party"
    And I click "Remind Joe Smith to vote"
    And I should see "Reminders sent"
    Then "Joe Smith" should receive a private reminder message
    And the private message should include a link to "Clown party"

  Scenario: Guest cannot remind users
    Given someone created an event named "Clown party"
    And "guest@example.com" was invited to the event "Clown party"
    And I am signed in as the guest "guest@example.com" named "Joe Schmoe"
    When I view the "Clown party" event
    Then I should not be able to remind everyone to vote
    And I should not be able to remind an individual user to vote

  @javascript
  Scenario: Owner can remind groups to vote
    Given I sign in and create an event named "Clown party"
    And I invite the Yammer group "scheddo-developers" to "Clown party"
    Then I should see "scheddo-developers" in the groups list
    When I click "Remind"
    And I should see "Reminders sent"
    Then I should see "Reminders sent" in the notice flash
    And "scheddo-developers" should receive a private reminder message
    And the private reminder message sent should be from "Ralph Robot"

  @javascript
  Scenario: Users can remind groups to vote
    Given I sign in and create an event named "Clown party"
    And I invite the Yammer group "scheddo-developers" to "Clown party"
    And I sign out
    And I am signed in as "Snoop" and I view the page for "Clown party"
    When I click "Remind"
    And I should see "Reminders sent"
    Then I should see "Reminders sent" in the notice flash
    And "scheddo-developers" should receive a private reminder message
    And the private reminder message sent should be from "Snoop"

  Scenario: Guest gets a reminder email
    Given I sign in and create an event named "Clown party"
    And "guest@example.com" was invited to the event "Clown party"
    And I sign out
    And I am signed in as "Snoop" and I view the page for "Clown party"
    And I invite "batman@example.com" to "Clown party"
    When I click "Remind Them!"
    Then "batman@example.com" should receive a reminder email with a link to "Clown party"
    And "batman@example.com" should receive an email that contains an image of "Snoop"
