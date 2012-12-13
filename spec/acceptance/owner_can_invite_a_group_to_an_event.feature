Feature: Owner can invite a group to an event

  @javascript
  Scenario: Owner invites a group
    Given I sign in and create an event named "sched.do Meeting"
    When I invite the Yammer group "scheddo-developers" to "sched.do Meeting"
    Then I should see "scheddo-developers" in the groups list
    And "scheddo-developers" should receive a private invitation message
    And the private invitation message sent should be from "Ralph Robot"
