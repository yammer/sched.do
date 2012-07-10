Feature: User can invite a group to an event

  Scenario: User invites a group
    Given I sign in and create an event named "Scheddo Meeting"
    When I invite the Yammer group "scheddo-developers" to "Scheddo Meeting"
    Then I should see "scheddo-developers" in the groups list
