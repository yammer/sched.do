@javascript
Feature: User cannot enter long Event names

  Scenario: User showed remaining characters
    Given I am signed in
    When I visit the new event page
    And I enter "12345678" in the name field
    Then I should see "20" in the text counter

  Scenario: User cannot enter long Event names
    Given I am signed in
    When I visit the new event page
    And I enter "1234567890123456789012345678901234567890" in the name field
    Then I should see "0" in the text counter
    And I should see "1234567890123456789012345678" in the name field
