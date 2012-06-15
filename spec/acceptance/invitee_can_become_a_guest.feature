Feature: Invitee can become a guest

  Scenario: Invitee becomes a guest
    Given someone created an event named "Clown party" with the following suggestions:
      | lunch  |
      | dinner |
    When I view the "Clown party" event
    Then I should be prompted to login or enter my name and email
    When I enter my name and email
    Then I should see "Clown party"
