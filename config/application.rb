require_relative 'boot'

require 'rails'
require 'active_model/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
require 'sprockets/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module GoalsAndIncentives
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    config.autoload_paths << Rails.root.join('lib/libs')
    config.eager_load_paths << Rails.root.join('lib/libs')

    config.generators.system_tests = nil
    config.generators do |g|
      g.test_framework :rspec, views: false
      g.fixture_replacement :factory_bot, dir: 'spec/factories'

      g.assets = false
      g.view_specs = false
      g.helper = false
      g.decorator = true
    end
  end
end
