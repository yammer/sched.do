Feature: Guest is shown appropriate login option

  @javascript
  Scenario: Guest is not shown name and email fields if coming from yammer.com
    Given someone created an event named "Clown party"
    When I go to yammer.com before I view the "Clown party" event
    Then I should not be prompted to enter my name and email

  Scenario: Guest is not shown name and email fields if they are a Yammer user
    Given I am signed in as "mason@example.com"
    And someone created an event named "Clown party"
    And I view the login form for the "Clown party" event
    And I fill in the guest fields with "mason@example.com" and "Mason"
    Then I should see "Please sign in with your Yammer account" in the notice flash
    And I should not be prompted to enter my name and email

  Scenario: Guest is shown name and email fields if not coming from yammer.com
    Given someone created an event named "Clown party"
    When I go to another site before I view the "Clown party" event
    Then I should be prompted to login or enter my name and email

  Scenario: Guest name and email are prepopulated when clicking links
    Given someone created an event named "Clown party" with a suggestion of "lunch"
    And "guest@example.com" was invited to the event "Clown party"
    And I am signed in as the guest "guest@example.com"
    When I view the "Clown party" event
    When I vote for "lunch"
    Then I should receive a vote confirmation email with a link to "Clown party"
    When I sign out
    And "guest@example.com" follows the link "change your vote" in his email
    Then I should see my email address "guest@example.com" prepopulated
    And I should see my name "Joe Schmoe" prepopulated

  Scenario: Guest is already logged in
    Given someone created an event named "Clown party" with a suggestion of "lunch"
    When I am signed in
    And I view the login form for the "Clown party" event
    Then I should be on the "Clown party" event page
