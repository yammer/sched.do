Feature: Owner can see OpenGraph metadata

  Scenario: Owner can see OpenGraph metadata
    Given I am signed in
    When I create an event named "Clown party" with a suggestion of "lunch"
    And I visit the event page for "Clown party"
    Then the OpenGraph image should contain "/logo.png"
    And there is an OpenGraph description
    And the OpenGraph title should be "Clown party"


  Scenario: Guest can see OpenGraph metadata
    Given I am signed in
    When I create an event named "Clown party" with a suggestion of "lunch"
    And I sign out
    And I visit the event page
    Then the OpenGraph image should contain "/logo.png"
    And there is an OpenGraph description
    And the OpenGraph title should be "Clown party"
