source 'https://rubygems.org'

gem 'rails', '3.2.8'
gem 'bootstrap-sass', '2.0.0'
gem 'bcrypt-ruby', '3.0.1'
gem 'faker', '1.0.1'
gem 'will_paginate', '3.0.3'
gem 'bootstrap-will_paginate', '0.0.6'
gem 'validates_email_format_of', '~> 1.5.3'
gem 'simple_form', '~> 2.0.2'
gem 'simple_calendar', '~> 0.0.5'

group :development do
  gem 'sqlite3', '1.3.5'
  gem 'annotate', '~> 2.4.1.beta'
  #removes assets getinfo form log
  gem 'quiet_assets'
  # changes server from webrick to thin to avoid the error msg
  gem 'thin'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '3.2.4'
  gem 'coffee-rails', '3.2.2'
  gem 'uglifier', '1.2.3'
end

gem 'jquery-rails'
gem 'thin'

group :test, :development do
  gem 'rspec-rails', '2.10.0'
  gem 'guard-rspec', '0.5.5'
  gem 'guard-spork', '0.3.2'
  gem 'guard-cucumber'
  gem 'spork', '0.9.0'
  gem 'whenever', :require => false
end

group :test do
  gem 'capybara', '1.1.2'
  gem 'launchy'
  gem 'factory_girl_rails', '1.4.0'
  gem 'cucumber-rails', '1.2.1', require: false
  gem 'database_cleaner', '0.7.0'
  gem 'rb-fsevent', :require => false
  gem 'growl', '1.0.3'
  gem 'timecop'
end

group :production do
  gem 'pg'
end
