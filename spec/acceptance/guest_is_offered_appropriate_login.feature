Feature: Guest is shown appropriate login option

  @javascript
  Scenario: Guest is not shown name and email fields if coming from yammer.com
    Given someone created an event named "Clown party"
    When I go to yammer.com before I view the "Clown party" event
    Then I should not be prompted to enter my name and email

  Scenario: Guest is shown name and email fields if not coming from yammer.com
    Given someone created an event named "Clown party"
    When I go to another site before I view the "Clown party" event
    Then I should be prompted to login or enter my name and email
