Feature: User can share sched.do with her Yammer network

  @javascript
  Scenario: User clicks "Share sched.do"
    Given I am signed in as "Bruce Lee"
    When I click "Share sched.do"
    Then I should see "Share it on your Yammer network"
    And the customize message field should contain "Check out this scheduling app"

  @javascript
  Scenario: User shares the app
    Given I am signed in as "Bruce Lee"
    When I click "Share sched.do"
    And I share the sched.do application
    Then I should see "Thank you for sharing sched.do!"
    And the share modal should not be visible

  @javascript
  Scenario: User opens the share app and sees the correct group list
    Given I am signed in as "Bruce Lee"
    And a group exists named "Scheddopeeps"
    When I click "Share sched.do"
    And I share the sched.do application
    And I click "Share sched.do"
    And I expand the Group list
    Then there should be 2 options in the group list

  @javascript
  Scenario: User shares the app and selects a group
    Given I am signed in as "Bruce Lee"
    And a group exists named "Scheddopeeps"
    When I click "Share sched.do"
    And I expand the Group list
    And I select "Scheddopeeps" from the group list
    And I share the sched.do application
    Then I should see "Thank you for sharing sched.do!"
    And the share modal should not be visible

  @javascript
  Scenario: User unsuccessfully shares the app
    Given I am signed in as "Bruce Lee"
    When I click "Share sched.do"
    And I share the sched.do app and get an error from the Yammer API
    Then I should see "There was an error with the request"

  @javascript
  Scenario: User creates an event and votes
    Given I am signed in as "Bruce Lee"
    And I create an event named "Clown party" with a suggestion of "lunch"
    And I view the "Clown party" event
    When I vote for "lunch"
    Then I should see "Let your coworkers know about sched.do"
    And the customize message field should contain "Check out this scheduling app"

  @javascript
  Scenario: User votes on an event she didn't create
    Given someone created an event named "Clown party" with a suggestion of "lunch"
    And I am signed in as "Bruce Lee"
    When I view the "Clown party" event
    And I vote for "lunch"
    Then I should see "Let your coworkers know about sched.do"
    And the customize message field should contain "Check out this scheduling app"

 @javascript
 Scenario: User votes on an event and shares sched.do
   Given I am signed in as "Bruce Lee"
   And I create an event named "Clown party" with a suggestion of "lunch"
   And I view the "Clown party" event
   When I vote for "lunch"
   Then I should see "Let your coworkers know about sched.do"
   And the customize message field should contain "Check out this scheduling app"
