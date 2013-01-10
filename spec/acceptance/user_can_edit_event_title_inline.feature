Feature: User can edit event title inline

  @javascript
  Scenario: User edits event title
    Given I am signed in
    When I create an event named "Clown party" with a suggestion of "lunch"
    And I visit the event page for "Clown party"
    And I click on the event title
    And I fill in the title with "Troll party"
    When I blur the title field
    Then I should see "Troll party" in the header
