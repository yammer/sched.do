Feature: Guest can login

  Scenario: Guest can login using an email address and name
    Given someone created an event named "Clown party"
    When I visit the event page for "Clown party"
    And I fill in the guest fields with "jack@example.com" and "Jack Black"
    Then I should be on the "Clown party" event page

  Scenario: First-time guest cannot login using only an email and no name
    Given someone created an event named "Clown party"
    And no guest exists with email "horatio@example.com"
    When I visit the event page for "Clown party"
    And I fill in the guest fields with only "horatio@example.com"
    Then I should be prompted to login or enter my name and email
    And I should not be on the "Clown party" event page
    And I should see "can't be blank" in the errors
