source "https://rubygems.org"

ruby "2.1.5"

gem "active_model_serializers"
gem "angularjs-rails"
gem "attr_extras"
gem "bourbon"
gem "coffee-rails"
gem "coffeelint"
gem "font-awesome-rails"
gem "haml-rails"
gem "high_voltage"
gem "jquery-rails"
gem "jshintrb"
gem "neat"
gem "newrelic_rpm"
gem "gitlab", :git => "https://github.com/larrylv/gitlab.git"
gem "omniauth-gitlab", :git => "https://github.com/larrylv/omniauth-gitlab.git"
gem "paranoia", "~> 2.0"
gem "pg"
gem "rails", "4.1.5"
gem "resque", "~> 1.22.0"
gem "resque-retry"
gem "resque-sentry"
gem "rubocop", "~> 0.27.0"
gem "sass-rails", "~> 4.0.2"
gem "uglifier", ">= 1.0.3"
gem "unicorn"
gem "dotenv-rails"

group :staging, :production do
  gem "rails_12factor"
end

group :development, :test do
  gem "byebug"
  gem "foreman"
  gem "konacha"
  gem "poltergeist"
  gem "rspec-rails", ">= 2.14"
  gem "quiet_assets"
  gem "pry"
  gem "pry-rails"
  gem "web-console"
  gem "thin"
end

group :test do
  gem "capybara", "~> 2.4.0"
  gem "capybara-webkit"
  gem "database_cleaner"
  gem "factory_girl_rails"
  gem "launchy"
  gem "shoulda-matchers"
  gem "webmock"
end
