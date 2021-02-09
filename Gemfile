# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }
ruby '2.7.1'
gem 'active_model_serializers'
gem 'bcrypt', '~> 3.1.7'
gem 'jwt'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 4.1'
gem 'rails', '~> 6.0.3', '>= 6.0.3.1'
gem 'figaro'
gem 'active_model_serializers'
gem 'active_storage_validations'
gem 'figaro'
gem 'bootsnap', '>= 1.4.2', require: false
gem 'rack-cors'
gem 'sprockets', '~>3.0'
gem 'will_paginate', '~> 3.0'

group :development, :test do
  gem 'rspec_api_documentation'
  gem 'rspec-rails'
  gem 'apitome', github: 'jejacks0n/apitome'
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'pry'
end

group :development do
  gem 'letter_opener'
  gem 'listen', '~> 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
