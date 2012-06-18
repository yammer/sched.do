Feature: Guests can vote on suggestions

  Scenario: Guest votes for a single suggestion
    Given someone created an event named "Clown party" with a suggestion of "lunch"
    And I am signed in as a guest
    When I view the "Clown party" event
    Then I should see that that "lunch" has 0 votes
    When I vote for "lunch"
    Then I should see that that "lunch" has 1 vote

  Scenario: Guest can undo their vote for a suggestion
    Given someone created an event named "Clown party" with a suggestion of "lunch"
    And I am signed in as a guest
    When I view the "Clown party" event
    And I vote for "lunch"
    Then I should see that that "lunch" has 1 vote
    When I unvote for "lunch"
    Then I should see that that "lunch" has 0 votes

  Scenario: Guest can vote for suggestions for different events
    Given someone created an event named "Clown party" with a suggestion of "lunch"
    And someone created an event named "Ninja party" with a suggestion of "dinner"
    And I am signed in as a guest
    When I view the "Clown party" event
    And I vote for "lunch"
    Then I should see that that "lunch" has 1 vote
    When I view the "Ninja party" event
    And I vote for "dinner"
    Then I should see that that "dinner" has 1 vote

  Scenario: Guest votes for multiple suggestions
    Given someone created an event named "Clown party" with the following suggestions:
      | lunch  |
      | dinner |
    And I am signed in as a guest
    When I view the "Clown party" event
    And I vote for "lunch"
    And I vote for "dinner"
    Then I should see that that "lunch" has 1 vote
    And I should see that that "dinner" has 1 vote
