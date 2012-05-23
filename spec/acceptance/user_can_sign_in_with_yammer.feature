Feature: User can sign in with Yammer

  Scenario: User signs in
    Given I have a Yammer account
    When I visit the homepage
    And I click "Sign in with Yammer"
    Then I should see the sign-in welcome message

  Scenario: User only has to sign in once
    Given I am signed in
    When I visit the homepage
    Then I should be redirected to the new event page
