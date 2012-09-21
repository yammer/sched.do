Feature: User can create an event

  Scenario: User creates event
    Given I am signed in
    When I create an event named "Clown party" with a suggestion of "lunch"
    Then I should see an event named "Clown party" with a suggestion of "lunch"
    And my network should see an activity message announcing the event

  @javascript
  Scenario: User creates event with multiple suggestions
    Given I am signed in
    When I create an event with the following suggestions:
      | breakfast |           |
      | lunch     | chipotle  |
      | lunch     | boloco    |
      | lunch     | moes      |
      | dinner    |           |
    Then I should see an event with the following suggestions in order:
      | breakfast |           |
      | lunch     | chipotle  |
      | lunch     | boloco    |
      | lunch     | moes      |
      | dinner    |           |

  @javascript
  Scenario: User adds an additional suggestion field
    Given I sign in and fill in the event name
    When I add another suggestion field
    And I fill out the event form with the following suggestions:
      | breakfast |
      | lunch     |
      | dinner    |
    And I submit the create event form
    Then I should see an event with the following suggestions in order:
      | breakfast |
      | lunch     |
      | dinner    |

  @javascript
  Scenario: User removes a suggestion field
    Given I sign in and fill in the event name
    When I fill out the event form with the following suggestions:
      | breakfast |
      | lunch     |
    And I remove the first suggestion
    And I submit the create event form
    Then I should see an event with the following suggestions in order:
      | lunch     |

  Scenario: User sees multiple suggestions after filling in invalid data
    Given I am signed in
    When I try to create an event with invalid data
    Then I should see multiple suggestions

  Scenario: User trys to create an event without a date or a title
    Given I am signed in
    And I visit the new event page
    When I press "Create event"
    Then I should see "This field is required" under the title
    And I should see "This field is required" under the first suggestion
