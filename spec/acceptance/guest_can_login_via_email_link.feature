Feature: Guests can login via email link

  Scenario: Guest clicks link in email and logs in
    Given I sign in and create an event named "Clown party"
    And I invite "guest@example.com" to "Clown party"
    And I sign out
    And "guest@example.com" should receive an email
    When "guest@example.com" follows the "Click Here" button in his email
    Then I should see my email address "guest@example.com" prepopulated
    And I fill in the fields with "guest@example.com" and "Guest" then submit
    And I should be on the "Clown party" event page

  Scenario: Guest email is prefilled when invited via email
    Given I sign in and create an event named "Clown party"
    When I invite "batman@example.com" to "Clown party"
    And I sign out
    And "batman@example.com" follows the "Click Here" button in his email
    Then I should see "Email" filled in with "batman@example.com"
