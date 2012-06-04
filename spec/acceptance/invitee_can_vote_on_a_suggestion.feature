Feature: Invitees can vote on suggestions

  Scenario: Invitee votes for a single suggestion
    Given I am signed in
    And I created an event named "Clown party" with a suggestion of "lunch"
    Then I should see that that "lunch" has 0 votes
    When I vote for "lunch"
    Then I should see that that "lunch" has 1 vote
