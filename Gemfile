source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.3.3"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.1.3.4"

# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 6.4.2"

# Use Redis adapter to run Action Cable in production
gem "redis", "~> 4.0"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem "rack-cors"

gem "jwt", "~> 2.7"

gem "pagy", "~> 6.1"

gem "sidekiq", ">= 7.2.4"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[mri mingw x64_mingw]
  gem "rspec-rails", "~> 6.0.3"
  gem "factory_bot_rails", "~> 6.2.0"
  gem "faker", "~> 3.2.1"
  gem "shoulda-matchers", "~> 5.0", require: false
  gem "rails-controller-testing", "~> 1.0"

  gem "rubocop", "~> 1.50.2", require: false
  gem "rubocop-rails", "~> 2.19.1", require: false
  gem "rubocop-performance", "~> 1.16.0", require: false
  gem "standard", "~> 1.28.1", require: false
  gem "rubocop-rspec", require: false
end

group :development do
  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
  gem 'brakeman', '~> 6.1', '>= 6.1.2'
  gem 'bundler-audit', '~> 0.9.1'
end
