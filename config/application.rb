require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Buho
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Use sidekiq to process Active Jobs (e.g. ActionMailer's deliver_later)
    config.active_job.queue_adapter = :sidekiq

    config.i18n.default_locale = :es
    config.time_zone = "Buenos Aires"
    config.i18n.available_locales = [:es]

    # Heroku asset precompilation
    config.assets.precompile << /\.(?:svg|eot|woff|ttf)$/

    # Generator config
    config.generators do |g|
      g.scaffold_stylesheet false
      # g.jbuilder false
      # g.test_framework  :test_unit, fixture: false
      g.javascripts false
      g.helper false
    end

    # Ensure non-standard paths are eager-loaded in production
    # (these paths are also autoloaded in development mode)
    # config.eager_load_paths += %W(#{config.root}/lib)
  end
end
