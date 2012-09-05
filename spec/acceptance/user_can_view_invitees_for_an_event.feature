Feature: User can view invitees for an event

  Scenario: Event owner views Yammer invitees
    Given a user exists with a name of "Joe Smith"
    And I am signed in
    When I create an event named "Party"
    And I invite the Yammer user "Joe Smith" to "Party"
    Then I should see "Joe Smith" in the list of invitees

  Scenario: Event owner views guest invitees
    Given a user exists with a name of "Joe Smith"
    And I am signed in
    When I create an event named "Party"
    And I invite "myfriend@example.com" to "Party"
    Then I should see "myfriend@example.com" in the list of invitees

  Scenario: Invitees who are not the owner only see invitees who have voted
    Given a user exists with a name of "Joe Smith"
    And I am signed in
    When I create an event named "Party"
    And I invite "myfriend@example.com" to "Party"
    And I invite "myotherfriend@example.com" to "Party"
    And I sign out
    And I am signed in as the guest "myfriend@example.com"
    Then I view the "Party" event
    Then I should not see "myotherfriend@example.com" in the list of invitees

  Scenario: Current user who is the Event owner should see their name at the top
    Given I have a Yammer account with name "Joe Smith"
    When I create an event named "Clown party"
    And I invite "myfriend@example.com" to "Clown party"
    And I invite "myotherfriend@example.com" to "Clown party"
    And I view the "Clown party" event
    Then I should see an event with the following invitees in order:
      | Joe Smith                 |
      | myotherfriend@example.com |
      | myfriend@example.com      |
