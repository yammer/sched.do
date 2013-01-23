Feature: User can share sched.do with her Yammer network

  Scenario: User clicks 'Share sched.do'
    Given I am signed in as 'Bruce Lee'
    When I click 'Share sched.do'
    Then I should see 'Share on your Yammer network'
    And I should see 'Did you know you can send your own polls for free?'

  @javascript
  Scenario: User shares the app
    Given I am signed in as 'Bruce Lee'
    When I click 'Share sched.do'
    And I share the sched.do application with my Yammer network
    Then I should see 'Thank you for sharing sched.do!'

  @javascript
  Scenario: User unsuccessfully shares the app
    Given I am signed in as 'Bruce Lee'
    When I click 'Share sched.do'
    And I share the sched.do app and get an error from the Yammer API
    Then I should see 'There was an error with the request'



