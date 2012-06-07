Feature: User can create an event

  Scenario: User creates event
    Given I am signed in
    When I create an event named "Clown party" with a suggestion of "lunch"
    Then I should see an event named "Clown party" with a suggestion of "lunch"

  Scenario: User creates event with multiple suggestions
    Given I am signed in
    When I create an event with the following suggestions:
      | breakfast |
      | lunch     |
      | dinner    |
    Then I should see an event with the following suggestions in order:
      | breakfast |
      | lunch     |
      | dinner    |

  Scenario: User sees multiple suggestions after filling in invalid data
    Given I am signed in
    When I try to create an event with invalid data
    Then I should see multiple suggestions

  Scenario: User sees event link after creating event
    Given I am signed in
    When I create an event
    Then I should see a link to that event
