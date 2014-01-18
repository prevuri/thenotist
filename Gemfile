source 'http://rubygems.org'

gem 'rails', '3.2.13'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'sqlite3'

# used for creating images out of pdf files

# used for connecting to AWS
gem 'aws-sdk'

# image manipulation
gem 'rmagick', :require => false

# production gems
gem 'rghost_rails', '~> 0.3.3'
gem 'devise'
gem 'omniauth'
gem 'faraday', '0.8' # if it's not version locked, then koala will break
gem 'koala', '~> 1.6.0'
gem 'omniauth-facebook'

# for asynchronous PDF conversion
# NOTE: have to install redis first: 'brew install redis'
#       and launch a redis server: 'redis-server /usr/local/etc/redis.conf'
#       and launch a sidekiq server: 'bundle exec sidekiq'
gem 'sidekiq'
gem 'sinatra', :require => false
gem 'slim'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'jquery-rails'
  gem 'jquery-ui-rails'
  gem 'bootstrap-sass'
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'haml-rails'
  gem 'spinjs-rails'
  gem "twitter-bootstrap-rails"
  gem "flat-ui-rails"
  gem 'underscore-rails'
  gem "font-awesome-rails"

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  # asynchronous upload
  gem 'jquery-fileupload-rails'

  gem 'uglifier', '>= 1.0.3'
end

group :development, :test do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'rspec-rails'
  # gem 'growl'
  gem 'guard'
  gem 'guard-bundler'
  gem 'guard-rspec'
  gem 'capybara', :git => 'git://github.com/jnicklas/capybara.git'
  gem 'capybara-webkit'
  gem 'database_cleaner'
  gem 'zeus'
  gem "parallel_tests"
  gem "zeus-parallel_tests"
  gem 'launchy'
  gem 'debugger'
  # gem 'factory_girl_rails'
  # gem 'rb-inotify', :require => false
  # gem 'rb-fsevent', :require => false
  # gem 'rb-fchange', :require => false
end



# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'
gem 'rubber'
gem 'open4'
gem 'gelf'
gem 'graylog2_exceptions', :git => 'git://github.com/wr0ngway/graylog2_exceptions.git'
gem 'graylog2-resque'
