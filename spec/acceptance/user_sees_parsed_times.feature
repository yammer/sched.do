@javascript
Feature: User sees parsed times

  Scenario: User sees parsed times
    Given I am signed in
    When I visit the new event page
    And I enter "13:00" in the first secondary field
    Then I should see "1:00pm" in the first secondary field

  Scenario: Times are only parsed once
    Given I am signed in
    When I visit the new event page
    And I enter "13:00" in the first secondary field
    And I enter "13:00" in the first secondary field
    Then I should see "13:00" in the first secondary field
