Feature: A user can create an event with a name

  Scenario: User creates an event with a name
    Given I am signed in
    When I fill in "Name" with "Clown party"
    And I press "Create event"
    Then I should see "Event successfully created."
    And I should see "Clown party"

  Scenario: User tries to create an event without a name
    Given I am signed in
    When I press "Create event"
    Then I should see "Please complete all required fields" in the error flash
    And I should see the error "can't be blank" on the "Name" field
