Hound-GitLab
=====

[![Build Status](https://travis-ci.org/larrylv/hound-gitlab.svg?branch=master)](http://travis-ci.org/larrylv/hound-gitlab?branch=master)
[![Code Climate](https://codeclimate.com/github/larrylv/hound-gitlab.png)](https://codeclimate.com/github/larrylv/hound-gitlab)

This project is originally a fork of [Hound](https://github.com/thoughtbot/hound) by thoughtbot,
and aims to support code reviews for GitLab.

Hound-GitLab reviews GitLab merge requests for style guide violations. [View the style
guide &rarr;](https://github.com/thoughtbot/guides/tree/master/style)

## Configure Hound-GitLab on Your Local Development Environment

1. After cloning the repository, run the setup script `./bin/setup`
2. Log into your Gitlab account and go to the [Account Page](https://gitlab.com/profile/account).
3. Copy the `Private token` to HOUND_GITLAB_TOKEN in `.env`, and then fetch your userid
   with that token for HOUND_GITLAB_USERID(this is tricky, I know...) in .env file.
   Note the setup script copies `.sample.env` to `.env` for you, if the
   file does not exist.
4. Edit `GITLAB_ENDPOINT` and `HOST` in .env file.
5. Run `foreman start`. Foreman will start the web server, `redis-server`, and
   the resque background job queue.

Testing
-----------

1. Set up your `development` environment as per above.
2. Run `rake` to execute the full test suite.

Contributing
------------

First, thank you for contributing!

Here a few guidelines to follow:

1. Write tests
2. Make sure the entire test suite passes locally and on Travis CI
3. Open a pull request on GitHub
4. [Squash your commits](https://github.com/thoughtbot/guides/tree/master/protocol/git#write-a-feature) after receiving feedback

There a couple areas we would like to concentrate on.

1. Add support for JavaScript
2. Add support for CSS and Sass
3. Write [style guides](app/models/style_guide) that don't currently exist and
   would enforce the
   [thoughtbot style guide](https://github.com/thoughtbot/guides).
