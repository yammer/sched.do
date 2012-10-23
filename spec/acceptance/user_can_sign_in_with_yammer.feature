Feature: User can sign in with Yammer

  Scenario: User signs in
    Given I have a Yammer account
    When I visit the homepage
    And I press "Sign in with Yammer"
    Then I should be redirected to the new event page

  Scenario: User only has to sign in once
    Given I am signed in
    When I visit the homepage
    Then I should be redirected to the new event page

  Scenario: User information updated on login
    Given I have a Yammer account with name "Bob Jones"
    When I create an event named "Clown party" with a suggestion of "lunch"
    Then I should see "Bob Jones"
    When I change my name to "Robert Jones"
    And I log out and sign back in again
    And I create an event named "Clown party" with a suggestion of "lunch"
    Then I should see "Robert Jones"
