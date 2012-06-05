Feature: User can edit suggestions for event

  Scenario: User edits event suggestion
    Given I am signed in
    And I created an event named "Clown party" with a suggestion of "lunch"
    When I follow "Edit event"
    When I suggest "dinner"
    And I press "Update event"
    Then I should see that the event was successfully updated
    And I should see a suggestion of "dinner"

  Scenario: User tries to edit event suggestion with invalid data
    Given I am signed in
    And I created an event named "Clown party" with a suggestion of "lunch"
    When I follow "Edit event"
    And I suggest an empty string
    And I press "Update event"
    Then I should see that the event was not successfully updated
