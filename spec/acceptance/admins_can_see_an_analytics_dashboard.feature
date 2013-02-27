Feature: Admin can see an analytics dashboard

  Scenario: Admin navigates to the analytics dashboard
    Given I am signed in as an admin
    When I navigate to the dashboard
    Then I should see "Sched.do/dashboard"

  Scenario: Non-Admin navigates to the analytics dashboard
    Given I am signed in
    When I navigate to the dashboard
    Then I should be redirected to the new event page

  Scenario: Admin views the Active Users report
    Given I am signed in as an admin
    When I navigate to the dashboard
    And I click "Active Users"
    Then I should see "An active user is anyone"
    And I should see a Google chart

  @javascript
  Scenario: Admin views the weekly view of the Active Users report
    Given I am signed in as an admin
    When I navigate to the dashboard
    And I click "Active Users"
    Then I should see a Google chart
    And I should see "Weeks"

  Scenario: Admin views the Polls Created report
    Given I am signed in as an admin
    When I navigate to the dashboard
    And I click "Polls Created"
    Then I should see "Number of polls created"
    And I should see a Google chart

  @javascript
  Scenario: Admin views the weekly view of the Polls Created report
    Given I am signed in as an admin
    When I navigate to the dashboard
    And I click "Polls Created"
    Then I should see a Google chart
    And I should see "Weeks"

  Scenario: Admin views the Users Invited report
    Given I am signed in as an admin
    When I navigate to the dashboard
    And I click "Users Invited"
    Then I should see "This dashboard should answer two basic questions"
    And I should see a Google chart

  @javascript
  Scenario: Admin views the weekly view of the Users Invited report
    Given I am signed in as an admin
    When I navigate to the dashboard
    And I click "Users Invited"
    Then I should see a Google chart
    And I should see "Weeks"

  @javascript
  Scenario: Admin views the Inivitee Conversion report
    Given I am signed in as an admin
    When I navigate to the dashboard
    And I click "Invitee Conversion"
    Then I should see "The question this dashboard should answer is"
    And I should see a Google chart
    And I should see "Weeks"
