Feature: Invitee can become a guest

  Scenario: Invitee becomes a guest
    Given someone created an event named "Clown party" with the following suggestions:
      | lunch  |
      | dinner |
    When I view the "Clown party" event
    Then I should be prompted to login or enter my name and email
    When I fill in the fields then submit
    Then I should see "Clown party"

  Scenario: Invitee cannot become a guest with an invalid email
    Given someone created an event named "Clown party" with the following suggestions:
      | lunch  |
      | dinner |
    When I view the "Clown party" event
    Then I should be prompted to login or enter my name and email
    When I enter my name and an invalid email
    Then I should be prompted to login or enter my name and email
