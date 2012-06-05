Feature: Invitees can vote on suggestions

  Scenario: Invitee votes for a single suggestion
    Given I am signed in
    And I created an event named "Clown party" with a suggestion of "lunch"
    Then I should see that that "lunch" has 0 votes
    When I vote for "lunch"
    Then I should see that that "lunch" has 1 vote

  Scenario: Invitee cannot vote for a suggestion more than once
    Given I am signed in
    And I created an event named "Clown party" with a suggestion of "lunch"
    When I vote for "lunch"
    Then I should see that that "lunch" has 1 vote
    When I vote for "lunch" again
    Then I should see that that "lunch" still has 1 vote

  Scenario: Invitee can vote for suggestions for different events
    Given I am signed in
    When I create an event named "Clown party" with a suggestion of "lunch"
    And I vote for "lunch"
    Then I should see that that "lunch" has 1 vote
    When I create an event named "Brunch" with a suggestion of "dinner"
    And I vote for "dinner"
    Then I should see that that "dinner" has 1 vote
