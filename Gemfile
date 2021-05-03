# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }
ruby '2.7.1'
gem 'aasm'
gem 'active_model_serializers'
gem 'active_storage_validations'
gem 'acts_as_favoritor'
gem 'bcrypt', '~> 3.1.7'
gem 'bootsnap', '>= 1.4.2', require: false
gem 'browser'
gem 'cityhash' # optional, for faster hashing (C-Ruby only)
gem 'faker'
gem 'figaro'
gem 'friendly_id', '~> 5.4.0'
gem 'geocoder'
gem 'identity_cache'
gem 'jwt'
gem 'kaminari'
gem 'meta-tags'
gem 'mysql2'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 4.1'
gem 'pundit'
gem 'rack-cors'
gem 'rails', '~> 6.0.3', '>= 6.0.3.1'
gem 'searchkick'
gem 'sprockets', '~>3.0'
gem 'ta-assets', git: 'git@github.com:jwachira/ta-assets.git', branch: 'master'
gem 'twilio-ruby'
gem 'webpacker', '~> 5.0'

gem 'dalli'

group :development, :test do
  gem 'apitome', github: 'jejacks0n/apitome'
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'pry'
  gem 'rspec_api_documentation'
  gem 'rspec-rails'
end

group :development do
  gem 'letter_opener'
  gem 'listen', '~> 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
