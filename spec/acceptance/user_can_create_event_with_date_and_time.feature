Feature: User can specify date and time for event

  Scenario: User creates event with date and time
    Given I am signed in
    And today is "2012-01-01"
    When I fill in "Name" with "Clown party"
    And I fill in "Time" with "2012-02-03 04:00 PM"
    And I submit the create event form
    Then I should see that the event was successfully created
    And I should see a suggested time of "Feb 03, 2012 04:00 pm"

  Scenario: User cannot create an event without a time
    Given I am signed in
    When I fill in "Name" with "Clown party"
    And I submit the create event form
    Then I should see the error "can't be blank" on the "Time" field

  Scenario: User cannot create an event in the past
    Given I am signed in
    And today is "2012-01-01"
    When I fill in "Name" with "Clown party"
    And I fill in "Time" with "2011-02-02 02:00 PM"
    And I submit the create event form
    Then I should see the error "must be in the future" on the "Time" field
