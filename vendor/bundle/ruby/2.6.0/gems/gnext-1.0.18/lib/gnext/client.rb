# frozen_string_literal: true

require 'gnext/config'
require 'gnext/middleware'
require 'gnext/endpoint_builder'

module Gnext
  class Client

    class << self
      attr_reader :instance_client

      def doctype(doctype_name)
        instance.doctype(doctype_name)
      end

      def instance
        @client ||= Client.new
      end
    end

    attr_reader :options

    def initialize(opts = {})
      raise ArgumentError, 'Please specify a hash of options' unless opts.is_a?(Hash)

      @options = Hash[Gnext.configuration.options.map do |option|
        [option, Gnext.configuration.send(option)]
      end]

      @options.merge! opts
    end

    # Force an authentication
    def authenticate!
      unless authentication_middleware
        raise AuthenticationError, 'No authentication middleware present'
      end

      logout

      middleware = authentication_middleware.new nil, self, options
      middleware.authenticate!
    end

    def logout
      connection.get('/api/method/logout') if cookies?
    end

    def doctype(doctype_name)
      EndpointBuilder.new(doctype_name, self)
    end

    def inspect
      "#<#{self.class} @options=#{@options.inspect}>"
    end

    def connection
      @connection ||= Faraday.new(options[:base_url],
                                  connection_options)  do |builder|

        # Handles reauthentication for 403 responses.
        if authentication_middleware
          builder.use authentication_middleware, self, options
        end

        # Sets the token or cookies in the headers.
        builder.use Gnext::Middleware::Authorization, self, options

        # Inject custom headers into requests
        builder.use Gnext::Middleware::CustomHeaders, self, options

        builder.request :retry, retry_middleware_options        
        
        # Parses returned JSON response into a hash.
        builder.response :json, { parser_options: { symbolize_names: true }, content_type: /\bjson$/ }

        # Raises errors for 40x responses.
        builder.response :raise_error

        builder.adapter adapter
      end
    end

    def adapter
      options[:adapter]
    end

    def cookies
      @cookies ||= HTTP::CookieJar.new
    end

    def cookies?
      cookie = cookies.cookies(options[:base_url])

      !cookie&.empty?
    end

    def connection_options
      {
        request: {
          timeout: options[:timeout],
          open_timeout: options[:timeout]
        },
        ssl: options[:ssl],
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        }
      }
    end

    def retry_middleware_options
      return options[:retry_options] unless options[:deep_merge_of_retry_options]

      {
        max: 2,
        interval: 0.05,
        interval_randomness: 0.5,
        backoff_factor: 2,
        exceptions: [
          Errno::ETIMEDOUT, 'Timeout::Error',
          Faraday::TimeoutError, Faraday::RetriableResponse,
          Timeout::Error,
          Faraday::BadRequestError,
          # Faraday::UnauthorizedError,
          # Faraday::ForbiddenError,
          Faraday::UnprocessableEntityError,
          Faraday::ServerError,
          Faraday::NilStatusError,
          Faraday::ConnectionFailed,
        ]
      }.deep_merge(options[:retry_options])
    end

    def authentication_middleware
      if password_authentication?
        Gnext::Middleware::Authentication::Password
      elsif token_authentication?
        Gnext::Middleware::Authentication::Token
      end
    end

    def password_authentication?
      options[:authentication_type].to_sym == :password &&
        options[:username] &&
        options[:password]
    end

    def token_authentication?
      options[:authentication_type].to_sym == :token &&
        options[:api_key] &&
        options[:api_secret]
    end
  end
end
