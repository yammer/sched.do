Feature: User can view an Event

  Scenario: Owner adds suggestions and sees it in the proper place
    Given I am signed in
    And I created an event named "Clown party" with a suggestion of "lunch"
    And I view the "Clown party" event
    When I click "Edit"
    When I add suggestion "dinner"
    And I press "Update event"
    Then I should see a suggestion of "dinner"
    And "lunch" should appear before "dinner" in the list

  @javascript
  Scenario: Owner creates Event and sees Secondary Suggestions in the correct order
    Given I am signed in
    And I created an event named "Clown party" with a suggestion of "lunch" with the following secondary suggestions:
      | chipotle |
      | subway   |
    And I view the "Clown party" event
    Then "chipotle" should appear before "subway" in the list

