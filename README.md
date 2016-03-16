Pecas, by Ombu Labs
========

[![Build Status](https://travis-ci.org/ombulabs/pecas.svg?branch=master)](https://travis-ci.org/ombulabs/pecas)
[![Code Climate](https://codeclimate.com/github/ombulabs/pecas/badges/gpa.svg)](https://codeclimate.com/github/ombulabs/pecas)

Pecas is a time tracking leaderboard for [http://letsfreckle.com](http://letsfreckle.com).

Setup
-----

To install Pecas in a development environment, you can follow the next steps:

### Ruby

    rvm install '2.1.2'

### First-time only

Clone the repo

    git clone git@github.com:ombulabs/pecas.git

Go to the project path

    cd path/to/pecas

Copy the YML database config

    cp config/database.yml.sample config/database.yml

Set up the database

    bundle exec rake db:migrate

Install dependencies

    bundle install

Setup and configure your `.env`

    cp .env.sample .env

You can setup your `COUNTRY_CODE` environment variable with an ISO 3166 country code.
Otherwise the E-Mails will be sent on holidays.

Start
-----

    rvm use 2.1.2@pecas
    bundle exec rvmsudo rails server

Import
------

Import the entries with:

    rake import:entries

Calculate the leaderboards with:

    rake calc:leaderboards

License
-----

[License]

  [license]: LICENSE
