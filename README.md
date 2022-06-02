# Pecas: Leaderboards for [Noko](https://nokotime.com)

[![Build Status](https://travis-ci.org/fastruby/pecas.svg?branch=master)](https://travis-ci.org/fastruby/pecas)
[![Code Climate](https://codeclimate.com/github/fastruby/pecas/badges/gpa.svg)](https://codeclimate.com/github/fastruby/pecas)

Pecas is a time tracking leaderboard for
[https://nokotime.com](https://nokotime.com).

## Getting started

To get started with the app, clone the repo and then install the needed gems running the setup script:

```bash
git clone git@github.com:fastruby/pecas.git
cd pecas
./bin/setup
```

## Environment Variables

The command `./bin/setup`, among other things, creates the `.env` file which contains the following env variables:

```yml
# .env.sample
NOKO_ACCOUNT_HOST=ombulabs
NOKO_TOKEN=foobar
SMTP_SERVER=smtp.sendgrid.net
SMTP_PORT=587
SMTP_DOMAIN=ombushop.com
SMTP_USER_NAME=ernesto@ombushop.com
SMTP_USER_PASSWORD=secret
COUNTRY_CODE="ar"
DATABASE_NAME="pecas"
BASIC_AUTH_NAME="user"
BASIC_AUTH_PASSWORD="secret"
```

Now, you just need to update the `NOKO_TOKEN` env with the correct value.
You can fetch the token value from the Noko app, after logging in, you can find the `API token` or create a new one under the `Connected Apps > Noko API > Personal Access Tokens` section.

The `BASIC_AUTH_NAME` and `BASIC_AUTH_PASSWORD` are already setup from the `.env.sample` file but you can change their values at any time, will be used for a basic http auth for the application.

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
This task is destined to be run once an hour (for best results - a few minutes
after the hour) as it will only notify users Slack reports as being in the
timezone currently within an hour of 8pm.

## Start

You can setup your `COUNTRY_CODE` environment variable with an ISO 3166 country code.
Otherwise the emails will be sent on holidays.

## Starting the Server

```bash
rails s
```

Go to `http://localhost:3000` and start your session with the `BASIC_AUTH_NAME` and `BASIC_AUTH_PASSWORD` values.

## Running Tests

```bash
rspec
```

## Using Docker

> NOTE: You'll need to have docker and docker-compose installed

Build the pecas docker image

```bash
docker-compose build
```

First-time only

```bash
docker-compose run web /bin/bash
./bin/setup
```

Start

```bash
docker-compose up
```

## Import

Import the entries with:

    rake import:entries

Calculate the leaderboards with:

    rake calc:leaderboards

## Demo Data

Generate demo data with:

    rake demo_data:setup

## Deleting old data

You can run this task specifying the number of months ago for the query:

    # delete entries with date older than 6 months ago
    MONTHS=6 rake delete_past_entries

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
