# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }
ruby '2.7.1'
gem 'aasm'
gem "aws-sdk-s3", require: false
gem 'active_model_serializers'
gem 'active_storage_validations'
gem 'acts_as_favoritor'
gem 'bcrypt', '~> 3.1.7'
gem 'figaro'
gem 'friendly_id', '~> 5.4.0'
gem 'jwt'
gem 'mysql2'
gem 'puma', '~> 4.1'
gem 'pundit'
gem 'rails'
gem 'searchkick'
gem 'sassc-rails'
gem 'kaminari'
gem 'geocoder'
gem 'faker'
gem 'bootsnap', '>= 1.4.2', require: false
gem 'rack-cors'
gem 'sprockets', '~>3.0'
gem 'twilio-ruby'
# gem 'ta-assets',  git: 'git@github.com:jwachira/ta-assets.git', branch: 'master'
gem 'webpacker', '~> 5.0'
gem 'browser'
gem 'meta-tags'
gem 'rollbar'
gem 'apitome', github: 'jejacks0n/apitome'
gem 'rspec_api_documentation'
gem 'whenever', require: false

group :development, :test do
  # gem 'apitome', github: 'jejacks0n/apitome'
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'pry'
  # gem 'rspec_api_documentation'
  gem 'rspec-rails'
end

group :development do
  gem 'letter_opener'
  gem 'listen', '~> 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :staging, :development do
  gem 'pry-rails'
end

group :deployment do
  gem 'capistrano', '~> 3.14.1', require: false
  gem 'capistrano-webpacker-precompile', require: false
  gem 'capistrano-maintenance'
  gem 'capistrano-passenger'
  gem 'capistrano-rails' # for capistrano/rails/*
  gem 'capistrano-rails-db'
  gem 'capistrano-rvm'
  gem 'capistrano-sidekiq'
  gem 'sshkit-sudo'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
