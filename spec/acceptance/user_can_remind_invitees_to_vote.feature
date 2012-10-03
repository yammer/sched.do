Feature: Owner can remind invitees to vote

  Scenario: Owner can remind all invitees to vote
    Given I sign in and create an event named "Clown party"
    And a user exists with a name of "Joe Smith" and yammer_network_id of "1"
    When I invite the Yammer user "Joe Smith" to "Clown party"
    And I invite "batman@example.com" to "Clown party"
    And I click "Remind Them!"
    Then I should see "Reminders sent" in the notice flash
    And "batman@example.com" should have 2 emails
    And "Joe Smith" should receive a private reminder message

  Scenario: Owner can remind a specific invitee to vote
    Given I sign in and create an event named "Clown party"
    And a user exists with a name of "Joe Smith"
    When I invite the Yammer user "Joe Smith" to "Clown party"
    And I click "Remind Joe Smith to vote"
    Then "Joe Smith" should receive a private reminder message

  Scenario: Owner can remind groups to vote
    Given I sign in and create an event named "Clown party"
    And I invite the Yammer group "scheddo-developers" to "Clown party"
    Then I should see "scheddo-developers" in the groups list
    When I click "Remind"
    Then I should see "Reminders sent" in the notice flash
    And "scheddo-developers" should receive a private reminder message
