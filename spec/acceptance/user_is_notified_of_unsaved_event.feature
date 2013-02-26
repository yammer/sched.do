Feature: User is notified of unsaved event

  @javascript
  Scenario: User fills in an Event title and reloads page
    Given I am signed in as "user@example.com"
    And I fill in the event name with "Picnic"
    When I click image link "sched.do"
    Then I should see "Your changes will not be saved." in the confirmation dialog

  @javascript
  Scenario: User does not fill in any fields and reloads page
    Given I am signed in as "user@example.com"
    And I visit the homepage
    When I click image link "sched.do"
    Then I should not see a confirmation dialog
