Feature: User can customize invitation text

  @javascript
  Scenario: User creates an event and invites users from the event page
    Given I am signed in
    And I create an event named "Clown party" with a suggestion of "tomorrow"
    When I visit the event page for "Clown party"
    And I fill in "user@example.com" in the invitation field
    Then I should see "I'm organizing Clown party on sched.do and I need your input." in the Invitation text field

  @javascript
  Scenario: User invites a user and customizes the invitation text
    Given I am signed in
    And I create an event named "Clown party" with a suggestion of "tomorrow"
    When I visit the event page for "Clown party"
    And I fill in the Invitation text field with "I like customization"
    And I fill in "bob@example.com" in the invitation field
    Then I should see "I like customization" in the Invitation text field

  @javascript
  Scenario: User customizes invite text on viral invite page and visit event page
    Given I am signed in
    And I create an event named "Clown party" with a suggestion of "tomorrow"
    And I fill in the multiple invite invitation text field with "I like customization"
    And I invite "bob@example.com" to "Clown party" via the autocomplete from the multiple invite page
    And I press "Invite"
    When I visit the event page for "Clown party"
    Then I should see "I like customization" in the Invitation text field
