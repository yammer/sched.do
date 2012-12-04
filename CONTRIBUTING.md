Contributing
============

Style Guide
-----------

Pull requests should conform to [this style guide](https://github.com/thoughtbot/guides/tree/master/style) and [this set of best practices](https://github.com/thoughtbot/guides/tree/master/best-practices).


Quick Overview
--------------

We love pull requests which follow [this protocol](https://github.com/thoughtbot/guides/tree/master/protocol#write-a-feature).

Here's a quick overview of the process (detail below):

1. Fork the repo.

2. Run the tests. We only take pull requests with passing tests, and it's great
to know that you have a clean slate.

3. Add a test for your change. Only refactoring and documentation changes
require no new tests. If you are adding functionality or fixing a bug, we need
a test!

4. Make the test pass.

5. Push to your fork and submit a pull request.

At this point you're waiting on us. We may suggest some changes or improvements
or alternatives. Once we approve, we will merge your branch in.

Some things that will increase the chance that your pull request is accepted,
taken straight from the Ruby on Rails guide:

* Use Rails idioms and helpers
* Include tests that fail without your code, and pass with it
* Update the documentation, the surrounding one, examples elsewhere, guides,
  whatever is affected by your contribution


Requirements
--------------

This is a Rails 3.2 application running on Ruby 1.9.3 and deployed to Heroku's
Cedar stack. It has an RSpec and Turnip test suite which should be run before
committing to the master branch.

Please remember this is open-source, so don't commit any passwords or API keys.
Those should go in config variables like `ENV['API_KEY']`.


Laptop setup
------------

Fork the repo and clone the app:

    git clone git@github.com:[GIT_USERNAME]/sched.do.git


Install Bundler 1.2.0.pre or higher:

    gem install bundler --pre

Set up the app:

    cd sched.do
    bundle --binstubs
    rake db:setup

Edit your .env file to store the keys given to you by Yammer:

    cp sample.env .env
    vi .env

Run the server using [foreman:](https://github.com/ddollar/foreman)

    foreman start -p 3000

We use foreman because it picks up the `.env` file. Also, it will use Thin as
the app server instead of Webrick, same as Heroku's Cedar stack.

Check it out:

    http://localhost:3000


Running tests
-------------

Run the whole test suite with:

    rake

Run individual specs like:

    rspec spec/models/user_spec.rb

Tab complete to make it even faster!

When a spec file has many specs, you sometimes want to run just what you're
working on. In that case, specify a line number:

    rspec spec/models/user_spec.rb:8


Syntax
------

* Two spaces, no tabs.
* No trailing whitespace. Blank lines should not have any spaces.
* Prefer `&&/||` over `and/or`.
* `MyClass.my_method(my_arg)` not `my_method( my_arg )` or `my_method my_arg`.
* `a = b` and not `a=b`.
* Follow the conventions you see used in the source already.

And in case we didn't emphasize it enough: we love tests!


Development process
-------------------

For details and screenshots of the feature branch code review process,
read [this blog post](http://robots.thoughtbot.com/post/2831837714/feature-branch-code-reviews).
