source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.1'

gem 'rails'
gem 'pg'
gem 'puma'
gem 'sass-rails'
gem 'webpacker'
gem 'haml'

gem 'dry-initializer'
gem 'dotenv-rails'

gem 'devise'

group :development, :test do
  gem 'byebug'
  gem 'pry-rails'
  gem 'pry-byebug'
  gem 'rspec-rails'
  gem 'database_cleaner'
  gem 'timecop'
end

group :test do
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'shoulda-matchers'
end

group :development do
  gem 'rubocop', '= 0.82.0'
  gem 'rubocop-rspec', '= 1.38.1'
  gem 'rubocop-performance', '= 1.5.2'
  gem 'rubocop-rails', '= 2.5.2'
  gem 'bundler-audit', github: 'rubysec/bundler-audit'

  gem 'foreman'
end
