Feature: User can edit date and time of event

  Scenario: User edits date and time of event
    Given I am signed in
    And today is "2012-01-01"
    And I created an event named "Clown party" at "February 3, 2012 4pm"
    When I follow "Edit event"
    And I fill in "Time" with "December 22, 2013 08:30"
    And I press "Update event"
    Then I should see that the event was successfully updated
    And I should see a suggested time of "Dec 22, 2013 08:30 am"

  Scenario: User tries to edit date and time of event with invalid data
    Given I am signed in
    And today is "2012-01-01"
    And I created an event named "Clown party" at "February 3, 2012 4pm"
    When I follow "Edit event"
    And I fill in "Time" with "nice try"
    And I press "Update event"
    Then I should see that the event was not successfully updated
    And I should see the error "not a valid datetime" on the "Time" field
