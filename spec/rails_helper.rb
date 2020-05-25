require 'spec_helper'

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)

# Prevent database truncation if the environment is production
abort('The Rails environment is running in production mode!') if Rails.env.production?

require 'rspec/rails'

Dir[Rails.root.join('spec/support/**/*.rb')].sort.each { |f| require f }

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec

    with.library :rails
  end
end

RSpec.configure do |config|
  config.include Shoulda::Matchers::ActiveRecord, type: :model
  config.include FactoryBot::Syntax::Methods
  config.include Devise::Test::IntegrationHelpers, type: :request

  config.before(:suite) do
    DatabaseCleaner.strategy = :deletion, { except: %w[spatial_ref_sys] }
    DatabaseCleaner.clean_with :truncation, except: %w[spatial_ref_sys]
  end
  config.around do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
  config.after(:suite) do
    DatabaseCleaner.clean
  end

  config.order = :random
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
end
