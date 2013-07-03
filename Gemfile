source 'https://rubygems.org'

gem 'rails', '3.2.8'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'sqlite3'

# used for creating images out of pdf files

# used for connecting to AWS
gem 'aws-sdk'

# production gems
gem 'rghost_rails', '~> 0.3.3'
gem 'devise'
gem 'omniauth'
gem 'koala', '~> 1.6.0'
gem 'omniauth-facebook'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'jquery-rails'
  gem 'bootstrap-sass'
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'haml-rails'
  gem 'spinjs-rails'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  # asynchronous upload
  gem 'jquery-fileupload-rails'

  gem 'uglifier', '>= 1.0.3'
end

group :development do
  #error portal
  gem 'better_errors'
  gem 'binding_of_caller'
end


group :development,:test do
  gem 'growl'
  gem 'guard'
  gem 'guard-bundler'
  gem 'guard-cucumber'
  gem 'guard-rspec'
  gem 'guard-livereload'
  gem 'factory_girl_rails'
  gem 'rb-inotify', :require => false
  gem 'rb-fsevent', :require => false
  gem 'rb-fchange', :require => false
end

group :test do
  gem 'capybara'
  gem 'faker'
  gem 'capybara-webkit'
  gem 'database_cleaner'
  gem 'rspec-rails'
  gem 'launchy'
  gem 'cucumber-rails', :require => false
end


gem "font-awesome-rails"

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
gem 'debugger'
