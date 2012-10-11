Feature: Guest invitees can invite others to an event

  Scenario: Guest invites another guest via email
    Given someone created an event named "Clown party"
    And "guest@example.com" was invited to the event "Clown party"
    And I am signed in as the guest "guest@example.com"
    When I view the "Clown party" event
    And I invite "dangermouse@example.com" to "Clown party"
    Then I should see "dangermouse@example.com" in the list of invitees
    And "dangermouse@example.com" should receive an email


    # Should disable autocomplete
    # Field should take a list of emails comma separated
    # Separate email copy should be sent
    # Invalid emails should be ignored with no error
