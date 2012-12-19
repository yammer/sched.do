Feature: Users can vote on suggestions
  @javascript
  Scenario: User votes for a single suggestion
    Given I am signed in
    And I created an event named "Clown party" with a suggestion of "lunch"
    Then I should see that "lunch" has 0 votes
    When I vote for "lunch"
    Then I should see that "lunch" has 1 vote

  Scenario: User votes twice for a single suggestion
    Given I am signed in
    And I created an event named "Clown party" with a suggestion of "lunch"
    When I vote for "lunch"
    And I vote for "lunch" again
    Then I should see "Sorry, you cannot duplicate votes"

  @javascript
  Scenario: User can undo their vote for a suggestion
    Given I am signed in
    And I created an event named "Clown party" with a suggestion of "lunch"
    When I vote for "lunch"
    Then I should see that "lunch" has 1 vote
    When I unvote for "lunch"
    Then I should see that "lunch" has 0 votes

  @javascript
  Scenario: User can vote for suggestions for different events
    Given I am signed in
    When I create an event named "Clown party" with a suggestion of "lunch"
    And I vote for "lunch"
    Then I should see that "lunch" has 1 vote
    When I create an event named "Brunch" with a suggestion of "dinner"
    And I vote for "dinner"
    Then I should see that "dinner" has 1 vote

  @javascript
  Scenario: User votes for multiple suggestions
    Given I am signed in
    And I create an event with the following suggestions:
      | lunch  |
      | dinner |
    When I vote for "lunch"
    And I vote for "dinner"
    Then I should see that "lunch" has 1 vote
    And I should see that "dinner" has 1 vote

  @javascript
  Scenario: User can vote on an event they were not invited to
    Given someone created an event named "Clown party" with a suggestion of "lunch"
    And I am signed in
    When I view the "Clown party" event
    And I vote for "lunch"
    Then I should see that "lunch" has 1 vote

  Scenario: User votes for a single suggestion and owner is notified
    Given I am signed in
    And I create an event named "Clown party" with a suggestion of "lunch"
    And I invite "batman@example.com" to "Clown party"
    When "batman@example.com" votes for "lunch"
    Then I should receive a vote notification email with a link to "Clown party"
