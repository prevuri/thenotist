source 'http://rubygems.org'

# common gems
gem 'rails', '3.2.13'
gem 'aws-sdk' # used for connecting to AWS
gem 'devise'
gem 'omniauth'
gem 'faraday', '0.8' # if it's not version locked, then koala will break
gem 'koala', '~> 1.6.0'
gem 'omniauth-facebook'
gem 'haml-rails'
gem 'pg'
gem 's3_direct_upload'
gem 'fast-stemmer'
gem 'meta-tags', :require => 'meta_tags'
gem 'sitemap_generator'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'd3-rails'
  gem 'jquery-rails'
  gem 'jquery-ui-rails'
  gem 'bootstrap-sass'
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'spinjs-rails'
  gem 'twitter-bootstrap-rails'
  gem 'flat-ui-rails'
  gem 'underscore-rails'
  gem "font-awesome-rails"
  gem "angularjs-rails"
  gem 'jquery-fileupload-rails'
  gem 'therubyracer', :platforms => :ruby
  gem 'uglifier', '>= 1.0.3'
end

group :production do
end

group :development, :test do
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
  gem 'parallel_tests'
  gem 'zeus-parallel_tests'
  gem 'launchy'
  gem 'debugger'
  gem 'teaspoon'
  gem 'phantomjs'
end
