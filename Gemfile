source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.2'

gem 'acts_as_paranoid'
gem 'bootsnap', require: false
gem 'countries', require: 'countries/global'
gem 'cssbundling-rails'
gem 'data_migrate'
gem 'devise', '~> 4.8.1'
gem 'jbuilder'
gem 'jsbundling-rails'
gem 'kaminari'
gem 'kramdown'
gem 'paper_trail'
gem 'pg', '~> 1.1'
gem 'pghero'
gem 'postmark-rails'
gem 'puma', '~> 5.0'
gem 'rails', '~> 7.0.7'
gem 'redis', '~> 4.0'
gem 'rss'
gem 'sidekiq'
gem 'sidekiq-status'
gem 'simple_form', '~> 5.1.0'
gem 'slack-notifier'
gem 'sprockets-rails'
gem 'stimulus-rails'
gem 'strong_password', '~> 0.0.9'
gem 'telegram-bot-ruby', '~> 1.0'
gem 'turbo-rails'
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

gem 'google-apis-gmail_v1', '~> 0.2.0'

group :production do
  gem 'lograge', '~> 0.3.1'
  gem 'syslogger', '~> 1.6.0'
end

group :development, :test do
  gem 'debug', platforms: %i[mri mingw x64_mingw]
end

group :development do
  gem 'annotate'
  gem 'capistrano'
  gem 'capistrano3-puma'
  gem 'capistrano-bundler', require: false
  gem 'capistrano-nvm', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano-rvm'
  gem 'letter_opener'
  gem 'rubocop', require: false
  gem 'rubocop-capybara', require: false
  gem 'rubocop-minitest', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'web-console'
end

group :test do
  gem 'capybara'
  gem 'minitest-stub_any_instance'
  gem 'mocha'
  gem 'selenium-webdriver'
  gem 'webdrivers'
  gem 'webmock'
end
