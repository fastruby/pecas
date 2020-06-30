# Pecas: Leaderboards for [Noko](https://nokotime.com)

[![Build Status](https://travis-ci.org/ombulabs/pecas.svg?branch=master)](https://travis-ci.org/ombulabs/pecas)
[![Code Climate](https://codeclimate.com/github/ombulabs/pecas/badges/gpa.svg)](https://codeclimate.com/github/ombulabs/pecas)

Pecas is a time tracking leaderboard for
[https://nokotime.com](https://nokotime.com).

## Setup

To install Pecas in a development environment, you can follow the next steps:

### First-time only

    git clone git@github.com:ombulabs/pecas.git
    cd path/to/pecas

Copy the database.yml config:

    ./bin/setup

You must setup your `NOKO_TOKEN` in the `.env` file. You can setup your
`COUNTRY_CODE` environment variable with an ISO 3166 country code. Otherwise
the emails will be sent on holidays.

## Start

    rails server

## Import

Import the entries with:

    rake import:entries

Calculate the leaderboards with:

    rake calc:leaderboards

## Demo Data

Generate demo data with:

    rake demo_data:setup

## License

[License]

  [license]: LICENSE

## Sponsorship

![FastRuby.io | Rails Upgrade Services](https://github.com/fastruby/pecas/raw/master/app/assets/images/fastruby-logo.png)


`Pecas` is maintained and funded by [FastRuby.io](https://fastruby.io). The names and logos for FastRuby.io are trademarks of The Lean Software Boutique LLC.
