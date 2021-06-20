require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)
Dotenv::Railtie.load



module Mtaco
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Locale
    config.i18n.default_locale = :es

    # Time zone
    config.time_zone = 'Lima'
    config.active_record.default_timezone = :local
   
    config.active_job.queue_adapter = :sidekiq

    if ENV['SMTP_URI']
      smtp_url = URI.parse(ENV['SMTP_URI'])
      config.action_mailer.smtp_settings = {
        address:   smtp_url.host,
        port:      smtp_url.port,
        user_name: smtp_url.user ? URI.decode_www_form_component(smtp_url.user) : nil,
        password:  smtp_url.password,
        enable_starttls_auto: Rack::Utils.parse_nested_query(smtp_url.query)['tls'].in?(['true', '1', 1, true, 'True', 'TRUE'])
      }
    end
  end
end
