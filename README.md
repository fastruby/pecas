# Pecas: Leaderboards for [Freckle](http://letsfreckle.com/)

[![Build Status](https://travis-ci.org/ombulabs/pecas.svg?branch=master)](https://travis-ci.org/ombulabs/pecas)
[![Code Climate](https://codeclimate.com/github/ombulabs/pecas/badges/gpa.svg)](https://codeclimate.com/github/ombulabs/pecas)

Pecas is a time tracking leaderboard for
[http://letsfreckle.com](http://letsfreckle.com).

## Setup

To install Pecas in a development environment, you can follow the next steps:

### First-time only

    git clone git@github.com:ombulabs/pecas.git
    cd path/to/pecas

Copy the database.yml config:

    cp config/database.yml.sample config/database.yml

Run the setup script:

    ./bin/setup

You must setup your `FRECKLE_TOKEN` in the `.env` file. You can setup your
`COUNTRY_CODE` environment variable with an ISO 3166 country code. Otherwise
the emails will be sent on holidays.

## Start

    rvmsudo rails server

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
