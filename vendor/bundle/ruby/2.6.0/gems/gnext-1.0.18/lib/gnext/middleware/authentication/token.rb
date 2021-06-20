# frozen_string_literal: true

module Gnext
  class Middleware::Authentication::Token < Gnext::Middleware::Authentication
    def authentication_url
      '/api/method/frappe.auth.get_logged_user'
    end

    def headers
      { 'Authorization': "token #{@options[:api_key]}:#{@options[:api_secret]}" }
    end
  end
end
