source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.2"

gem "devise", "~> 4.8.1"
gem "kramdown"
gem "rails", "~> 7.0.7"
gem "sprockets-rails"
gem "pg", "~> 1.1"
gem "puma", "~> 5.0"
gem "jsbundling-rails"
gem "turbo-rails"
gem "scout_apm"
gem "sidekiq"
gem "sidekiq-status"
gem "simple_form", "~> 5.1.0"
gem "slack-notifier"
gem "stimulus-rails"
gem "cssbundling-rails"
gem "jbuilder"
gem "redis", "~> 4.0"
gem 'rss'
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]
gem "bootsnap", require: false

group :production do
  gem "lograge", "~> 0.3.1"
  gem "syslogger", "~> 1.6.0"
end

group :development, :test do
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
end

group :development do
  gem 'annotate'
  gem 'capistrano'
  gem 'capistrano3-puma'
  gem 'capistrano-rails', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-rvm'
  gem 'capistrano-nvm', require: false
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "mocha"
  gem "selenium-webdriver"
  gem "webdrivers"
end
