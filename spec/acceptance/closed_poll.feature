Feature: Closed poll

  Scenario: Owner closes an existing poll
    Given I sign in and create an event named "Fun Event"
    When I visit the event page for "Fun Event"
    And I close the poll
    Then I should see a closed poll
    And I cannot visit the edit page for "Fun Event"

  Scenario: Non-owner user does not see a close button
    Given someone created an event named "Party"
    When I am signed in
    And I view the "Party" event
    Then I should not be able to close the poll

  Scenario: User views a closed poll
    Given someone created a closed event named "Party"
    And I am signed in
    When I visit the event page for "Party"
    Then I should see a closed poll

  Scenario: Guest views a closed poll
    Given someone created a closed event named "Party"
    And "guest@example.com" was invited to the event "Party"
    And I am signed in as the guest "guest@example.com"
    When I visit the event page for "Party"
    Then I should see a closed poll

  Scenario: Guest does not see a close button
    Given someone created an event named "Party"
    And "guest@example.com" was invited to the event "Party"
    And I am signed in as the guest "guest@example.com"
    When I view the "Party" event
    Then I should not be able to close the poll
