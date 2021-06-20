# frozen_string_literal: true

module Gnext
  class Middleware::CustomHeaders < Gnext::Middleware
    def call(env)
      headers = @options[:request_headers]
      env[:request_headers].merge!(headers) if headers.is_a?(Hash)

      @app.call(env)
    end
  end
end
