Feature: Owner can create an event

  Scenario: Owner creates event
    Given I am signed in
    When I create an event named "Clown party" with a suggestion of "lunch"
    And I visit the event page for "Clown party"
    Then I should see an event named "Clown party" with a suggestion of "lunch"
    And my network should see an activity message announcing the event

  @javascript
  Scenario: Owner creates event after pressing the "Add Another Date" and "Add Another Time" buttons
    Given I am signed in
    And I fill in the event name with "Event"
    And I suggest "lunch"
    And I click "Add Another Date"
    And I click "Add Another Time"
    And I should see 3 primary fields
    And I should see 4 secondary fields
    When I successfully submit the create event form for "Event"
    And I visit the event page for "Event"
    Then I should see an event named "Event" with a suggestion of "lunch"
    And my network should see an activity message announcing the event

  @javascript
  Scenario: Owner creates event with multiple suggestions
    Given I am signed in
    And I create an event "Clown party" with the following suggestions:
      | breakfast |           |
      | lunch     | chipotle  |
      | lunch     | boloco    |
      | lunch     | moes      |
      | dinner    |           |
    When I visit the event page for "Clown party"
    Then I should see an event with the following suggestions in order:
      | breakfast |           |
      | lunch     | chipotle  |
      | lunch     | boloco    |
      | lunch     | moes      |
      | dinner    |           |

  @javascript
  Scenario: Owner adds an additional suggestion field
    Given I sign in and fill in the event name as "Clown party"
    When I add another suggestion field
    And I fill out the event form with the following suggestions:
      | breakfast |
      | lunch     |
      | dinner    |
    And I successfully submit the create event form for "Clown party"
    And I visit the event page for "Clown party"
    Then I should see an event with the following suggestions in order:
      | breakfast |
      | lunch     |
      | dinner    |

  @javascript
  Scenario: Owner removes a suggestion field
    Given I sign in and fill in the event name as "Clown party"
    When I fill out the event form with the following suggestions:
      | breakfast |
      | lunch     |
    And I remove the first suggestion
    And I successfully submit the create event form for "Clown party"
    And I visit the event page for "Clown party"
    Then I should see an event with the following suggestions in order:
      | lunch     |

   Scenario: Owner sees multiple suggestions after filling in invalid data
     Given I am signed in
     When I try to create an event with invalid data
     Then I should see multiple suggestions

   Scenario: Owner trys to create an event without a date or a title
     Given I am signed in
     And I visit the new event page
     When I press 'Create event'
     Then I should see 'This field is required' under the title
     And I should see 'This field is required' under the first suggestion
