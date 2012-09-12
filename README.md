Sched.do
========

Create events. Have your friends vote on them. See what times work for
everybody.

This app showcases Yammer integration such as adding activity messages,
messaging your friends, messaging groups, and open graph integration.

Requirements
--------------
This is a Rails 3.2 app running on Ruby 1.9.3 and deployed to Heroku's Cedar
stack. It has an RSpec and Turnip test suite which should be run before
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

    cd sched-do
    bundle
    rake db:create
    rake db:migrate

Edit your .env file:

    cp sample.env .env
    vi .env #Use the keys given to you by Yammer

Run the server with foreman:

    foreman start -p 3000

We use foreman because foreman picks up on the `.env` file.

Go to the server:

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

Development process
-------------------

To run the app in development mode, use Foreman.

    foreman start -p 3000

It will pick up on the Procfile and use Thin as the app server instead of
Webrick, which will also be used by Heroku's Cedar stack.

    gem install git_remote_branch
    git pull --rebase
    grb create feature-branch
    rake

This creates a new branch for your feature. Name it something relevant. Run the
tests to make sure everything's passing. Then, implement the feature.

    rake
    git add -A
    git commit -m "my awesome feature"
    git push -u origin feature-branch

Open up the Github repo, change into your feature-branch branch. Press the "Pull
request" button. It should automatically choose the commits that are different
between master and your feature-branch. Create a pull request on your forked
repository, then set the Head Repo to the original sched.do codebase.

Be sure to submit complete test coverage for your change/new feature and a clear
description of the issue you're addressing.

For more details and screenshots of the feature branch code review process,
read [this blog post](http://robots.thoughtbot.com/post/2831837714/feature-branch-code-reviews).

Most importantly
----------------
Have fun!

License
-------
sched.do is Copyright © 2012 Yammer, inc. It is free software and may be
redistributed under the terms specified in the [LICENSE.md](https://github.com/yammer/sched.do/blob/master/LICENSE.md) file.
