# frozen_string_literal: true

module Gnext
  class Middleware < Faraday::Middleware
    require 'gnext/middleware/authentication'
    require 'gnext/middleware/authorization'
    require 'gnext/middleware/custom_headers'

    def initialize(app, client, options)
      super(app)

      @app = app
      @client = client
      @options = options
    end

    def client
      @client
    end
  end
end
