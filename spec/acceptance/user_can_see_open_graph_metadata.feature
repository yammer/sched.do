Feature: User can see OpenGraph metadata

  Scenario: User can see OpenGraph metadata
    Given I am signed in
    When I create an event named "Clown party" with a suggestion of "lunch"
    Then the OpenGraph image should be "http://www.example.com/assets/logo.png"
    And there is an OpenGraph description
    And the OpenGraph title should be "Clown party"


  Scenario: Guest can see OpenGraph metadata
    Given I am signed in
    When I create an event named "Clown party" with a suggestion of "lunch"
    And I sign out
    And I visit the event page
    Then the OpenGraph image should be "http://www.example.com/assets/logo.png"
    And there is an OpenGraph description
    And the OpenGraph title should be "Clown party"
