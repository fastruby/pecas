def next?
  File.basename(__FILE__) == "Gemfile.next"
end
source 'https://rubygems.org'

ruby '2.5.8'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
if next?
  gem 'rails', '~> 5.1.0'
else
  gem 'rails', '~> 5.0.1'
end

# Use sqlite3 as the database for Active Record

# Use SCSS for stylesheets
gem 'sass-rails'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails'

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

gem 'json'

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
