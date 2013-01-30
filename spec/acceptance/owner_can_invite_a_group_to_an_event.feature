Feature: Owner can invite a group to an event

  @javascript
  Scenario: Owner invites a group
    Given I sign in and create an event named "sched.do Meeting"
    And I visit the event page for "sched.do Meeting"
    When I invite the Yammer group "scheddo-developers" to "sched.do Meeting"
    Then I should see "scheddo-developers" in the groups list
    And group "scheddo-developers" should receive a private invitation message
    And the private invitation message should be sent regarding "sched.do Meeting"
    And the private invitation message sent should be from "Ralph Robot"

  @javascript
  Scenario: Owner invites a group
    Given I sign in and create an event named "sched.do Meeting"
    And I visit the event page for "sched.do Meeting"
    When I invite the Yammer group "scheddo-developers" to "sched.do Meeting" by typing "sched" into the autocomplete
    Then I should see "scheddo-developers" in the groups list
