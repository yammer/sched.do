Feature: User cannot delete suggested time if there is only one
  @javascript
  Scenario: User includes one secondary suggestion and cannot delete it
    Given I am signed in as "user@example.com"
    And I fill in the event name with "Party time, excellent"
    When I add suggestion "Tomorrow"
    And I enter "10am" in the first secondary field
    Then I cannot remove the first suggestion

  @javascript
  Scenario: User includes two secondary suggestions and can remove one
    Given I am signed in as "user@example.com"
    And I fill in the event name with "Day of Fun Fun Fun"
    And I add suggestion "Tomorrow"
    When I enter "10am" in the first secondary field
    And I add another secondary suggestion field
    Then I can remove one of the suggestions
