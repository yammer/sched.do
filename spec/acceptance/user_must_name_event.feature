Feature: A user must name an event

  Scenario: User tries to create an event without a name
    Given I am signed in
    And I submit the create event form
    Then I should see "Please complete all required fields" in the error flash
    And I should see the error "can't be blank" on the "Name" field
