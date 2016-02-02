Freckler, by Ombu Labs
========

[![Build Status](https://travis-ci.org/ombulabs/freckler.svg?branch=master)](https://travis-ci.org/ombulabs/freckler)
[![Code Climate](https://codeclimate.com/github/ombulabs/freckler/badges/gpa.svg)](https://codeclimate.com/github/ombulabs/freckler)

Freckler is a time tracking leaderboard for [http://letsfreckle.com](http://letsfreckle.com).

Setup
-----

To install Freckler in a development environment, you can follow the next steps:

### Ruby

    rvm install '2.1.2'

### First-time only

Clone the repo

    git clone git@github.com:ombulabs/freckler.git

Go to the project path

    cd path/to/freckler

Copy the YML database config

    cp config/database.yml.sample config/database.yml

Set up the database

    bundle exec rake db:migrate

Install dependencies

    bundle install

Setup and configure your `.env`

    cp .env.sample .env

Start
-----

    rvm use 2.1.2@freckler
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
