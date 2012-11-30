Feature: Guests can vote on suggestions

  Scenario: Guest votes for a single suggestion
    Given someone created an event named "Clown party" with a suggestion of "lunch"
    And "guest@example.com" was invited to the event "Clown party"
    And I am signed in as the guest "guest@example.com"
    When I view the "Clown party" event
    Then I should see that "lunch" has 0 votes
    When I vote for "lunch"
    Then I should see that "lunch" has 1 vote

  Scenario Outline: Guest gets a vote confimation email
    Given someone <profile_image> a profile image created an event named "Clown party" with a suggestion of "lunch"
    And "guest@example.com" was invited to the event "Clown party"
    And I am signed in as the guest "guest@example.com"
    When I view the "Clown party" event
    And I vote for "lunch"
    Then I should receive a vote confirmation email with a link to "Clown party"
    And the email <should_include_image> contain an image of the owner of "Clown party"

    Examples:
      | profile_image | should_include_image |
      | with          | should               |
      | without       |should not            |

  Scenario: Guest can undo their vote for a suggestion
    Given someone created an event named "Clown party" with a suggestion of "lunch"
    And "guest@example.com" was invited to the event "Clown party"
    And I am signed in as the guest "guest@example.com"
    When I view the "Clown party" event
    And I vote for "lunch"
    Then I should see that "lunch" has 1 vote
    When I unvote for "lunch"
    Then I should see that "lunch" has 0 votes

  Scenario: Guest can vote for suggestions for different events
    Given someone created an event named "Clown party" with a suggestion of "lunch"
    And someone created an event named "Ninja party" with a suggestion of "dinner"
    And "guest@example.com" was invited to the event "Clown party"
    And "guest@example.com" was invited to the event "Ninja party"
    And I am signed in as the guest "guest@example.com"
    When I view the "Clown party" event
    And I vote for "lunch"
    Then I should see that "lunch" has 1 vote
    When I view the "Ninja party" event
    And I vote for "dinner"
    Then I should see that "dinner" has 1 vote

  Scenario: Guest votes for multiple suggestions
    Given someone created an event named "Clown party" with the following suggestions:
      | lunch  |
      | dinner |
    And "guest@example.com" was invited to the event "Clown party"
    And I am signed in as the guest "guest@example.com"
    When I view the "Clown party" event
    And I vote for "lunch"
    And I vote for "dinner"
    Then I should see that "lunch" has 1 vote
    And I should see that "dinner" has 1 vote

  Scenario: Guest votes on an event without prior invitation
    Given someone created an event named "Clown party" with a suggestion of "lunch"
    And I am signed in as the guest "guest@example.com" named "Example Guest"
    When I view the "Clown party" event
    Then I should see "Example Guest" in the list of invitees
    And I vote for "lunch"
    Then I should see that "lunch" has 1 vote
