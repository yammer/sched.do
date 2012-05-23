Rails app
=========

This is a Rails 3.1 app running on Ruby 1.9.2 and deployed to Heroku's Cedar
stack. It has an RSpec and Turnip test suite which should be run before
committing to the master branch.

Laptop setup
------------

Use [thoughtbot dotfiles](https://github.com/thoughtbot/dotfiles) to get
commands like `git up` and `git down` for a clean git history.

Clone the app:

    git clone git@github.com:thoughtbot/sched-do.git

Set up the app:

    cd sched-do
    bundle
    bake db:create
    bake db:migrate

Running tests
-------------

Run the whole test suite with:

    bake

Run individual specs like:

    s spec/models/user_spec.rb

Tab complete to make it even faster!

When a spec file has many specs, you sometimes want to run just what you're working on. In that case, specify a line number:

    s spec/models/user_spec.rb:8

Development process
-------------------

To run the app in development mode, use Foreman, which was installed from the `laptop` script:

    foreman start

It will pick up on the Procfile and use Thin as the app server instead of Webrick, which will also be used by Heroku's Cedar stack.

    git pull --rebase
    grb create feature-branch
    bake

This creates a new branch for your feature. Name it something relevant. Run the tests to make sure everything's passing. Then, implement the feature.

    bake
    git add -A
    git commit -m "my awesome feature"
    git push origin feature-branch

Open up the Github repo, change into your feature-branch branch. Press the "Pull
request" button. It should automatically choose the commits that are different
between master and your feature-branch. Create a pull request and share the link
in Campfire with the team. When someone else gives you the thumbs-up, you can
merge into master:

    git up
    git down
    git push origin master

For more details and screenshots of the feature branch code review process, read [this blog post](http://robots.thoughtbot.com/post/2831837714/feature-branch-code-reviews).

Most importantly
----------------

Have fun!
