# Pecas: Leaderboards for [Noko](https://nokotime.com)

[![Build Status](https://travis-ci.org/fastruby/pecas.svg?branch=master)](https://travis-ci.org/fastruby/pecas)
[![Code Climate](https://codeclimate.com/github/fastruby/pecas/badges/gpa.svg)](https://codeclimate.com/github/fastruby/pecas)

Pecas is a time tracking leaderboard for
[https://nokotime.com](https://nokotime.com).

## Setup

To install Pecas in a development environment, you can follow the next steps:

### Requirements

- Docker
- Docker-Compose
- Git

### First-time only

    git clone git@github.com:fastruby/pecas.git
    cd path/to/pecas
    docker-compose build
    docker-compose run web /bin/bash
    ./bin/setup

You must setup your `NOKO_TOKEN` in the `.env` file. You can setup your
`COUNTRY_CODE` environment variable with an ISO 3166 country code. Otherwise
the emails will be sent on holidays.

You must also setup `BASIC_AUTH_NAME` and `BASIC_AUTH_PASSWORD` variables in the `.env` file that will be used for a basic http auth for the application.

## Slack Notifications

If you want to use Pecas to send Slack messages you'll also need to setup
`SLACK_OAUTH_TOKEN` in the `.env` file. This requires a `SLACK_OAUTH_TOKEN`
generated with the following scopes:

* chat:write
* usergroups:read
* users.profile:read
* users:read
* users:read.email

Once set up we can use the rake task `notify:send_noko_format_warning['<name of slack group to alert>']`.
This task is desined to be run once an hour (for best results - a few minutes
after the hour) as it will only notify users Slack reports as being in the
timezone currently within an hour of 8pm.

## Start

    docker-compose up

## Import

Import the entries with:

    rake import:entries

Calculate the leaderboards with:

    rake calc:leaderboards

## Demo Data

Generate demo data with:

    rake demo_data:setup

## Contributing

Bug reports and pull requests are welcome on GitHub at [https://github.com/fastruby/pecas](https://github.com/fastruby/pecas). This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

When Submitting a Pull Request:

- If your PR closes any open GitHub issues, please include `Closes #XXXX` in your comment

- Please include a summary of the change and which issue is fixed or which feature is introduced.

- If changes to the behavior are made, clearly describe what changes.

- If changes to the UI are made, please include screenshots of the before and after.

## License

[License]

[license]: LICENSE

## Sponsorship

![FastRuby.io | Rails Upgrade Services](app/assets/images/fastruby-logo.png)

`Pecas` is maintained and funded by [FastRuby.io](https://fastruby.io). The names and logos for FastRuby.io are trademarks of The Lean Software Boutique LLC.
