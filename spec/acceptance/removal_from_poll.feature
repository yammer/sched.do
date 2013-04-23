Feature: Removal from poll

  Scenario: User removes themselves from a poll
    Given someone created an event named "Party"
    And I visit the event page for "Party"
    And I am signed in
    When I remove myself as a participant
    Then I should see "Successfully removed from Party" in the notice flash
    And I should be on my profile page
    And I should not see "Party" as one of my events

  Scenario: Guest removes themselves from a poll
    Given someone created an event named "Party"
    And I visit the event page for "Party"
    And I am signed in as the guest "guest@example.com"
    When I remove myself as a participant
    Then I should see "Successfully removed from Party" in the notice flash
    And I should be on the homepage

  Scenario: Owner removes user from a poll
    Given I sign in and create an event named "Party"
    And I invite "guest@example.com" to "Party"
    When I remove "guest@example.com" as a participant
    Then I should see "Successfully removed from Party" in the notice flash
    And I should be on the "Party" event page
    And I should not see "guest@example.com" in the list of invitees
