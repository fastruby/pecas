def next?
  File.basename(__FILE__) == "Gemfile.next"
end
source 'https://rubygems.org'

ruby '2.5.8'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
if next?
  gem 'rails', '~> 5.0.1'
else
  gem 'rails', '~> 4.2.1'
end

# Use sqlite3 as the database for Active Record

# Use SCSS for stylesheets
if next?
  gem 'sass-rails'
else
  gem 'sass-rails', '~> 4.0.3'
end

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
if next?
  gem 'coffee-rails'
else
  gem 'coffee-rails', '~> 4.0.0'
end

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

if next?
  gem 'json'
else
  gem 'json', '~> 1.8.6'
end


group :production do
  gem 'pg', '~> 0.20.0'
  gem 'rails_12factor'
end

group :development do
  gem 'pry-byebug', platform: [:ruby_20], require: false
  gem "sqlite3", "~> 1.3.6"
  gem 'spring'
  gem 'next_rails'
end

group :test do
  gem 'rails-controller-testing'
  gem 'rspec-rails'
  gem 'email_spec'
  gem 'factory_girl_rails'
  gem 'simplecov', require: false
  gem 'simplecov-console', require: false
  gem 'coveralls', require: false
end

group :development, :test do
  gem 'vcr'
  gem 'webmock'
  gem 'faraday'
  gem "byebug"
end

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]
