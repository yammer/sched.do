Feature: User can invite a group to an event

  @javascript
  Scenario: User invites a group
    Given someone created an event named "sched.do Meeting"
    And I am signed in as "Bruce Lee" and I view the page for "sched.do Meeting"
    When I invite the Yammer group "scheddo-developers" to "sched.do Meeting"
    Then I should see "scheddo-developers" in the groups list
    And group "scheddo-developers" should receive a private invitation message
    And the private invitation message should be sent regarding "sched.do Meeting"
    And the private invitation message sent should be from "Bruce Lee"
