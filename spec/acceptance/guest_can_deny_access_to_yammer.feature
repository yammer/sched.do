Feature: User denies access to Yammer

  Scenario: User denies access to Yammer
    Given I deny access to Yammer
    Then I should see "You denied access to Yammer"
