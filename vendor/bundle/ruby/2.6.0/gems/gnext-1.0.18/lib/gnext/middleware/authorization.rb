# frozen_string_literal: true

module Gnext
  class Middleware::Authorization < Gnext::Middleware
    AUTH_HEADER = 'Authorization'
    COOKIE_HEADER = 'Cookie'

    def call(env)
      @env = env

      if client.password_authentication? && client.cookies?
        authorization_by_cookies
      elsif client.token_authentication?
        authorization_by_token
      else
        raise Gnext::AuthorizationError
      end

      @app.call(env)
    end


    def authorization_by_cookies
      cookies = client.cookies.cookies(@options[:base_url])
      cookie_value = HTTP::Cookie.cookie_value(cookies)
      if @env[:request_headers][COOKIE_HEADER]
        unless @env[:request_headers][COOKIE_HEADER] == cookie_value
          @env[:request_headers][COOKIE_HEADER] = cookie_value + ';' + @env[:request_headers][COOKIE_HEADER]
        end
      else
        @env[:request_headers][COOKIE_HEADER] = cookie_value
      end
    end

    def authorization_by_token
      @env[:request_headers][AUTH_HEADER] = "token #{@options[:api_key]}:#{@options[:api_secret]}"
    end
  end
end
