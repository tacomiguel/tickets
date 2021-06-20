# frozen_string_literal: true

module Gnext
  class Middleware::Authentication < Gnext::Middleware
    require 'gnext/middleware/authentication/password'
    require 'gnext/middleware/authentication/token'

    # Rescue from 401's, authenticate then raise the error again so the client
    # can reissue the request.
    def call(env)
      @env = env
      @app.call(env)
    rescue Gnext::AuthorizationError => e
      authenticate!
      retry
    end

    def authenticate!
      client.logout

      response = connection.post authentication_url do |req|
        req.headers = headers
      end

      if response.status >= 500
        raise Gnext::ServerError, error_message(response)
      elsif response.status != 200
        raise Gnext::AuthenticationError, error_message(response)
      end

      set_cookies_has_exists!(response)

      @options[:authentication_callback]&.call(response.body)

      response.body
    end

    def authentication_url
      raise NotImplementedError, "The method .authentication_url has not been implemented by #{self.class.name}"
    end
    
    def headers
      raise NotImplementedError, "The method .headers has not been implemented by #{self.class.name}"
    end

    def connection
      @connection ||= Faraday.new(faraday_options) do |builder|
        builder.response :json, parser_options: { symbolize_names: true }

        builder.adapter @options[:adapter]
      end
    end

    def error_message(response)
      return response.status.to_s unless response.body

      "#{response.body[:message] || 'Error'}: #{response.body[:exc]} " \
        "(#{response.status})"
    end

    def set_cookies_has_exists!(response)
      if set_cookie = response.headers['Set-Cookie']
        client.cookies.parse(set_cookie, @options[:base_url])
      end
    end

    private

    def faraday_options
      {
        url: @options[:base_url],
        ssl: @options[:ssl]
      }
    end
  end
end
