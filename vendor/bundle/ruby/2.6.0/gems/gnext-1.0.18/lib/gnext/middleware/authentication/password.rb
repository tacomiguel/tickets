# frozen_string_literal: true

module Gnext
  # Authentication middleware used if username and password flow is used
  class Middleware::Authentication::Password < Gnext::Middleware::Authentication
    def authentication_url
      "/api/method/login?usr=#{@options[:username]}&pwd=#{@options[:password]}"
    end

    def headers
      {}
    end
  end
end
