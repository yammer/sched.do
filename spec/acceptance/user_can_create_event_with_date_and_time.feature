Feature: User can specify date and time for event

  Scenario: User creates event with date and time
    Given I am signed in
    And today is "2012-01-01"
    When I fill in the event name with "Clown party"
    And I fill in the event time with "February 3, 2012 04:00 PM"
    And I submit the create event form
    Then I should see that the event was successfully created
    And I should see a suggested time of "Feb 03, 2012 04:00 pm"

  Scenario: User cannot create an event without a time
    Given I am signed in
    When I fill in the event name with "Clown party"
    And I submit the create event form
    Then I should see a presence error on the time field

  Scenario: User cannot create an event in the past
    Given I am signed in
    And today is "Jan 1, 2012"
    When I fill in the event name with "Clown party"
    And I fill in the event time with "Feb 2, 2011 2pm"
    And I submit the create event form
    Then I should see an error relating to the future on the time field
