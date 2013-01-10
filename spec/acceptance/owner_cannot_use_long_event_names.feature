@javascript
Feature: Owner cannot enter long Event names

  Scenario: Owner showed remaining characters
    Given I am signed in
    When I visit the new event page
    And I enter "1234567890" in the name field
    Then I should see the appropriate change in the character counter

  Scenario: Owner can enter long Event names
    Given I am signed in
    When I visit the new event page
    And I enter a long name in the Event title field
    Then I should see "-30" in the text counter

  Scenario: Owner cannot submit long Event names
    Given I am signed in
    When I visit the new event page
    And I enter a long name in the Event title field
    And I submit the create event form
    Then I should see a length error on the event name field

  Scenario: Owner sees updated text length on edit
    Given I sign in and create an event named "1234567890"
    And I visit the event page for "1234567890"
    When I edit the event
    Then I should see the appropriate change in the character counter
