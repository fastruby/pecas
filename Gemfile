source 'https://rubygems.org'

ruby "2.4.5"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 4.2'
# Use sqlite3 as the database for Active Record

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.3'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer',  platforms: :ruby

gem 'dotenv-rails'
gem 'noko'

gem 'twitter-bootstrap-rails'

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0',          group: :doc

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

gem 'holidays'

gem 'json', '~> 1.8.6'

group :production do
  gem 'pg', '~> 0.20.0'
  gem 'rails_12factor'
end

group :development do
  gem 'pry-byebug', platform: [:ruby_20], require: false
  gem "byebug"
  gem "sqlite3", "~> 1.3.6"
  gem 'spring'
end

group :test do
  gem 'rspec-rails'
  gem 'email_spec'
  gem 'factory_girl_rails'
  gem 'coveralls', require: false
end

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]
