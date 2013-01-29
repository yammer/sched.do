Feature: Users can vote on suggestions
  @javascript
  Scenario: User votes for a single suggestion
    Given I am signed in
    And I created an event named "Clown party" with a suggestion of "lunch"
    And I visit the event page for "Clown party"
    When I vote for "lunch"
    Then I should see that "lunch" has 1 vote

  @javascript
  Scenario: User votes for a single secondary suggestion
    Given I am signed in
    And I create an event "Clown party" with the following suggestions:
      | breakfast| eggs     |
      | lunch    | chipotle |
    And I visit the event page for "Clown party"
    When I vote for secondary "chipotle"
    Then I should see that secondary "chipotle" has 1 vote
    And I should see that secondary "eggs" has 0 votes

  @javascript
  Scenario: User votes for multiple secondary suggestions
    Given I am signed in
    And I create an event "Clown party" with the following suggestions:
      | breakfast| eggs     |
      | lunch    | chipotle |
    And I visit the event page for "Clown party"
    When I vote for secondary "chipotle"
    And I vote for secondary "eggs"
    Then I should see that secondary "chipotle" has 1 vote
    And I should see that secondary "eggs" has 1 votes

  @javascript
  Scenario: User unvotes for a single secondary suggestion
    Given I am signed in
    And I create an event "Clown party" with the following suggestions:
      | breakfast| eggs     |
      | lunch    | chipotle |
    And I visit the event page for "Clown party"
    And I vote for secondary "chipotle"
    When I unvote for secondary "chipotle"
    Then I should see that secondary "chipotle" has 0 votes
    And I should see that secondary "eggs" has 0 votes

  Scenario: User votes twice for a single suggestion
    Given I am signed in
    And I created an event named "Clown party" with a suggestion of "lunch"
    And I visit the event page for "Clown party"
    When I vote for "lunch"
    And I vote for "lunch" for the "Clown party" again
    Then I should see "Sorry, you cannot duplicate votes"

  @javascript
  Scenario: User can undo their vote for a suggestion
    Given I am signed in
    And I created an event named "Clown party" with a suggestion of "lunch"
    And I visit the event page for "Clown party"
    When I vote for "lunch"
    And I close the share sched.do modal
    Then I should see that "lunch" has 1 vote
    When I unvote for "lunch"
    And I close the share sched.do modal
    Then I should see that "lunch" has 0 votes

  @javascript
  Scenario: User can vote for suggestions for different events
    Given I am signed in
    When I create an event named "Clown party" with a suggestion of "lunch"
    And I visit the event page for "Clown party"
    And I vote for "lunch"
    Then I should see that "lunch" has 1 vote
    When I create an event named "Brunch" with a suggestion of "dinner"
    And I visit the event page for "Brunch"
    And I vote for "dinner"
    Then I should see that "dinner" has 1 vote

  @javascript
  Scenario: User votes for multiple suggestions
    Given I am signed in
    And I create an event "Clown party" with the following suggestions:
      | lunch  |
      | dinner |
    And I view the "Clown party" event
    When I vote for "lunch"
    And I close the share sched.do modal
    And I vote for "dinner"
    And I close the share sched.do modal
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

  @javascript
  Scenario: User votes for a single suggestion
    Given I am signed in
    And I created an event named "Clown party" with a suggestion of "lunch"
    And I visit the event page for "Clown party"
    And I vote for "lunch"
    When I sign in as a different user
    And I visit the event page for "Clown party"
    Then I should see that "lunch" has 1 vote
