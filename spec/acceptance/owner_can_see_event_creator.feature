Feature: Owner can tell who created an Event

  Scenario: When I navigate to the EventShow page I should see the Creater
    Given I have a Yammer account with name 'Britton'
    When I create an event named "Clown party" with a suggestion of "lunch"
    Then I view the "Clown party" event
    And I should see 'Britton' within the created by section
