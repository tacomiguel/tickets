# frozen_string_literal: true

# Shamelessly pulled from https://github.com/restforce/restforce/blob/master/lib/restforce/config.rb

module Gnext
  class << self

    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield configuration
    end
  end

  class Configuration
    class Option
      attr_reader :configuration, :name, :options

      def self.define(*args)
        new(*args).define
      end

      def initialize(configuration, name, options = {})
        @configuration = configuration
        @name = name
        @options = options
        @default = options.fetch(:default, nil)
      end

      def define
        write_attribute
        define_method if default_provided?
        self
      end

      private

      attr_reader :default
      alias default_provided? default

      def write_attribute
        configuration.send :attr_accessor, name
      end

      def define_method
        our_default = default
        our_name    = name
        configuration.send :define_method, our_name do
          instance_variable_get(:"@#{our_name}") ||
            instance_variable_set(
              :"@#{our_name}",
              our_default.respond_to?(:call) ? our_default.call : our_default
            )
        end
      end
    end

    class << self
      attr_accessor :options

      def option(*args)
        option = Option.define(self, *args)
        (self.options ||= []) << option.name
      end
    end

    # The base url from erpnext
    option :base_url, default: lambda { ENV['ERP_API_URL'] }

    # The username to use during login.
    option :username, default: lambda { ENV['ERP_USER'] }

    # The password to use during login.
    option :password, default: lambda { ENV['ERP_PASSWORD'] }

    # The security api token to use during login.
    option :api_key, default: lambda { ENV['ERP_API_KEY'] }

    # The security api secret to use during login.
    option :api_secret, default: lambda { ENV['ERP_API_SECRET'] }

    # The type of authentication is used to determine which one to use in case
    # there is availability for `token` authentication or `password` authentication
    option :authentication_type, default: lambda { ENV['ERP_AUTHENTICATION_TYPE'] || :token }

    # The options per handle retry middleware
    option :retry_options, default: {}

    # The options per handle retry middleware
    option :deep_merge_of_retry_options, default: true

    # Faraday request read/open timeout.
    option :timeout

    # Faraday adapter to use. Defaults to Faraday.default_adapter.
    option :adapter, default: lambda { Faraday.default_adapter }

    # A Proc that is called with the response body after a successful authentication.
    option :authentication_callback

    # Set SSL options
    option :ssl, default: {}

    # A Hash that is converted to HTTP headers
    option :request_headers

    def options
      self.class.options
    end
  end
end
