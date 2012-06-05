Feature: User can create event with suggestions

  Scenario: User creates event with suggestion
    Given I am signed in
    When I fill in the event name with "Clown party"
    And I suggest "lunch"
    And I submit the create event form
    Then I should see that the event was successfully created
    And I should see a suggestion of "lunch"

  Scenario: User cannot create an event without a suggestion
    Given I am signed in
    When I fill in the event name with "Clown party"
    And I submit the create event form
    Then I should see a presence error on the suggestion field
