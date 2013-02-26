Feature: A fix necessary in the aftermath of the impersenation bug

  Scenario: User is logged in when their access token is erased
    Given I am signed in
    When my access token is erased
    And I visit the new event page
    Then I should be signed out
