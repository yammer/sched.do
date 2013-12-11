Feature: Closed poll

  @javascript
  Scenario: Owner chooses a winning option
    Given I am signed in as "owner@example.com"
    And a user exists with a name of "Jane Doe"
    And I create an event "Fun Event" with the following suggestions:
      | Monday  |
      | Tuesday |
    And I invite the Yammer user "Jane Doe" to "Fun Event"
    And I invite the Yammer group "Developers" to "Fun Event"
    And I invite "guest@example.com" to "Fun Event" via the autocomplete
    And I reset Yammer endpoint stats
    When I visit the event page for "Fun Event"
    And I choose "Tuesday" as the winning option
    Then I should see a closed poll
    And Yammer should receive 3 private messages
    And the private message should include "I've chosen Tuesday for Fun Event"
    And "guest@example.com" should receive an email with the text "I've chosen Tuesday for Fun Event"
    And "owner@example.com" should receive an email with the text "Invitees who voted for Tuesday"

  @javascript
  Scenario: Owner chooses a winning option for a time-based event
    Given I am signed in
    And I create an event "Fun Event" with the following suggestions:
      | Monday  |
      | Tuesday |
    When I visit the event page for "Fun Event"
    And I choose "Tuesday" as the winning option
    Then I should see the "Add to Calendar" link

  @javascript
  Scenario: Owner chooses a winning option for a non time-based event
    Given I am signed in
    And I create an event "Fun Event" with the following suggestions:
      | Happy |
      | Sad   |
    When I visit the event page for "Fun Event"
    And I choose "Happy" as the winning option
    Then I should not see the "Add to Calendar" link

  Scenario: Non-owner user does not see a button to choose a winner
    Given someone created an event named "Party"
    When I am signed in
    And I view the "Party" event
    Then I should not be able to choose a winning option

  Scenario: User views a closed poll
    Given someone created a closed event named "Party"
    And I am signed in
    When I visit the event page for "Party"
    Then I should see a closed poll
    And I should see the open graph discussion feed

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
