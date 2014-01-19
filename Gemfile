source 'http://rubygems.org'

# common gems
gem 'rails', '3.2.13'
# gem 'rmagick', :require => false  # image manipulation
# gem 'rghost_rails', '~> 0.3.3'  # used for creating images out of pdf files
gem 'aws-sdk' # used for connecting to AWS
gem 'devise'
gem 'omniauth'
gem 'faraday', '0.8' # if it's not version locked, then koala will break
gem 'koala', '~> 1.6.0'
gem 'omniauth-facebook'
gem 'haml-rails'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'jquery-rails'
  gem 'jquery-ui-rails'
  gem 'bootstrap-sass'
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'spinjs-rails'
  gem "twitter-bootstrap-rails"
  gem "flat-ui-rails"
  gem 'underscore-rails'
  gem "font-awesome-rails"
  gem 'therubyracer', :platforms => :ruby
  gem 'jquery-fileupload-rails' # asynchronous upload
  gem 'uglifier', '>= 1.0.3'
end

group :production do
  gem 'pg'
end

group :development, :test do
  gem 'sqlite3'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'rspec-rails'
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
end

# for asynchronous PDF conversion
# NOTE: have to install redis first: 'brew install redis'
#       and launch a redis server: 'redis-server /usr/local/etc/redis.conf'
#       and launch a sidekiq server: 'bundle exec sidekiq'
# gem 'sidekiq'
# gem 'sinatra', :require => false
# gem 'slim'


# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
gem 'capistrano'
gem 'rubber'
gem 'open4'
gem 'gelf'
gem 'graylog2_exceptions', :git => 'git://github.com/wr0ngway/graylog2_exceptions.git'
gem 'graylog2-resque'
