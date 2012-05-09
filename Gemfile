source 'https://rubygems.org'

gem 'rails', '3.2.3'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'sqlite3'

group :production do
  # gems specifically for Heroku go here
  gem "pg"
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'bourbon'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platform => :ruby

  gem 'uglifier', '>= 1.0.3'
end

group :test, :development do
  gem 'guard'
  gem "growl"
  gem 'rb-fsevent', :require => false if RUBY_PLATFORM =~ /darwin/i
  
  gem 'rspec-rails'
  gem "webrat"
  gem "spork-rails"
  gem "capybara"
  
  gem 'guard-rspec'
end

gem 'jquery-rails'

gem 'nokogiri'

# To use ActiveModel has_secure_password
gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'
