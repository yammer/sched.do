Feature: Custom invitation text for multiple invitations

  @javascript
  Scenario: Owner leaves default invitation text and invites a user
    Given I sign in and create an event named "Cookie party"
    And a user exists with a name of "Jane Doe"
    When I invite the Yammer user "Jane Doe" to "Cookie party" from the multiple invite page
    And I press "Invite"
    Then I should see "I'm organizing Cookie party on sched.do and I need your input." in the Invitation text field
    And "Jane Doe" should receive 1 private message
    And the private message should include "I'm organizing Cookie party on sched.do and I need your input."

  @javascript
  Scenario: Owner leaves default invitation text and invites guest by email
    Given I sign in and create an event named "Cookie party"
    And I invite "chocolate@example.com" to "Cookie party" via the autocomplete from the multiple invite page
    When I press "Invite"
    Then I should see "I'm organizing Cookie party on sched.do and I need your input." in the Invitation text field
    And "chocolate@example.com" should receive an email with the text "I'm organizing Cookie party"

  @javascript
  Scenario: User adds custom invitation text
    Given I sign in and create an event named "Cookie party"
    And a user exists with a name of "Jane Doe"
    And I fill in the multiple invite invitation text field with "Come eat cookies!"
    When I invite the Yammer user "Jane Doe" to "Cookie party" from the multiple invite page
    And I press "Invite"
    Then I should see "Come eat cookies!" in the Invitation text field
    And "Jane Doe" should receive 1 private message
    And the private message should include "Come eat cookies!"

  @javascript
  Scenario: User adds custom invitation text and invites someone by email
    Given I sign in and create an event named "Cookie party"
    And I fill in the multiple invite invitation text field with "Come eat cookies!"
    And I invite "chocolate@example.com" to "Cookie party" via the autocomplete from the multiple invite page
    When I press "Invite"
    Then I should see "Come eat cookies!" in the Invitation text field
    And "chocolate@example.com" should receive an email with the text "Come eat cookies!"

  @javascript
  Scenario: User adds custom invitation text and sees it on the event page
    Given I sign in and create an event named "Cookie party"
    And a user exists with a name of "Jane Doe"
    And I fill in the multiple invite invitation text field with "Come eat cookies!"
    When I invite the Yammer user "Jane Doe" to "Cookie party" from the multiple invite page
    And I press "Invite"
    Then I should see "Come eat cookies!" in the Invitation text field
