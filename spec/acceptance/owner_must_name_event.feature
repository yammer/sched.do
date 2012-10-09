Feature: A user must name an event

  Scenario: Owner tries to create an event without a name
    Given I am signed in
    And I submit the create event form
    Then I should see the error "This field is required" on the "event_name" field
