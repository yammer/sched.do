Feature: Closed poll

  @javascript
  Scenario: Owner chooses a winning option
    Given I am signed in
    And I create an event "Fun Event" with the following suggestions:
      | Monday  |
      | Tuesday |
    When I visit the event page for "Fun Event"
    And I choose "Tuesday" as the winning option
    Then I should see a closed poll

  Scenario: Non-owner userdoes not see a button to choose a winner
    Given someone created an event named "Party"
    When I am signed in
    And I view the "Party" event
    Then I should not be able to choose a winning option

  Scenario: User views a closed poll
    Given someone created a closed event named "Party"
    And I am signed in
    When I visit the event page for "Party"
    Then I should see a closed poll

  Scenario: User cannot vote on a closed poll
    Given someone created a closed event named "Party"
    And I am signed in
    When I visit the event page for "Party"
    Then I cannot vote

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
    Then I should not be able to choose a winning option
