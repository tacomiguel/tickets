# frozen_string_literal: true

require 'httparty'
require 'faraday'
require 'faraday_middleware'
require 'http-cookie'
require 'json'

require 'gnext/version'
require 'gnext/client'

module Gnext
  class Error < StandardError; end
  class ServerError < Error; end
  class AuthenticationError < Error; end
  class AuthorizationError < Error; end

  class Api
    def initialize(baseUrl, user, password)
      @baseUrl = baseUrl.dup.delete_suffix!("/") || baseUrl
      @user = user
      @password = password
      @cookies = nil
      @auth = false
      login
    end

    def login
      endpoint = "#{@baseUrl}/api/method/login?usr=#{@user}&pwd=#{@password}"
      response = HTTParty.post(endpoint)
      data = JSON.parse(response.body) rescue {}
      if response.code == 200 && data["message"] == "Logged In"
        parse_cookies(response)
        @auth = true
      else
        @cookies = nil
        @auth = false
        raise ":::Auth Error:::"
      end
    end

    def logout
      endpoint = "#{@baseUrl}/?cmd=logout"
      response = HTTParty.post(endpoint)
      if response.code == 200
        p "::: LOGOUT :::"
        @cookies = nil
        @auth = false
      end
    end

    def get_total_count_customers
      raise ":::Unauthenticated:::" unless @auth
      endpoint = "#{@baseUrl}/?doctype=Customer&fields=[\"count(name)+AS+total_count\"]&cmd=frappe.desk.reportview.get"
      response = HTTParty.get(endpoint, headers: { 'Cookie' => @cookies } )
      data = JSON.parse(response.body) rescue {}
      { total_count: data["message"]["values"][0][0] }
    end

    def get_all_customers(fields = ["*"])
      raise ":::Unauthenticated:::" unless @auth
      total_count = get_total_count_customers
      endpoint = "#{@baseUrl}/api/resource/Customer?fields=#{fields.to_s}&limit_start=0&limit_page_length=#{total_count["total_count"]}"
      response = HTTParty.get(endpoint, headers: { 'Cookie' => @cookies } )
      JSON.parse(response.body) rescue {}
    end

    def get_customer_by_document(document, fields = ["*"])
      raise ":::Unauthenticated:::" unless @auth
      endpoint = "#{@baseUrl}/api/resource/Customer?filters=[[\"customer_code\",\"=\",\"#{CGI.escape(document.to_s.strip)}\"]]&fields=#{fields.to_s}"
      response = HTTParty.get(endpoint, headers: { 'Cookie' => @cookies } )
      JSON.parse(response.body) rescue {}
    end

    def get_company_customer_by_user(user, fields = ["*"])
      raise ":::Unauthenticated:::" unless @auth
      endpoint = "#{@baseUrl}/api/resource/Customer?filters=[[\"customer_user\",\"=\",\"#{CGI.escape(user.to_s.strip)}\"],[\"customer_type\",\"=\",\"Company\"]]&fields=#{fields.to_s}"
      response = HTTParty.get(endpoint, headers: { 'Cookie' => @cookies } )
      JSON.parse(response.body) rescue {}
    end

    def get_sub_customers_by_company_client_name(name, fields = ["*"])
      raise ":::Unauthenticated:::" unless @auth
      endpoint = "#{@baseUrl}/api/resource/Customer?filters=[[\"business_group\",\"=\",\"#{CGI.escape(name.to_s.strip)}\"]]&fields=#{fields.to_s}&limit_start=0&limit_page_length=100"
      response = HTTParty.get(endpoint, headers: { 'Cookie' => @cookies } )
      JSON.parse(response.body) rescue {}
    end

    def get_contacts_by_customer_name(name, fields = ["*"])
      raise ":::Unauthenticated:::" unless @auth
      endpoint = "#{@baseUrl}/api/resource/Contact?filters=[[\"name\",\"like\",\"%#{CGI.escape(name)}%\"]]&fields=#{fields.to_s}"
      response = HTTParty.get(endpoint, headers: { 'Cookie' => @cookies } )
      JSON.parse(response.body) rescue {}
    end

    def get_contact_info_by_name(name)
      raise ":::Unauthenticated:::" unless @auth
      endpoint = "#{@baseUrl}/?doctype=Contact&name=#{CGI.escape(name)}&cmd=frappe.desk.form.load.getdoc"
      response = HTTParty.get(endpoint, headers: { 'Cookie' => @cookies } )
      JSON.parse(response.body) rescue {}
    end

    def get_contract_by_document(document, fields = ["*"])
      raise ":::Unauthenticated:::" unless @auth
      endpoint = "#{@baseUrl}/api/resource/Contrato?filters=[[\"customer_code\",\"=\",\"#{CGI.escape(document.to_s.strip)}\"]]&fields=#{fields.to_s}"
      response = HTTParty.get(endpoint, headers: { 'Cookie' => @cookies } )
      data = JSON.parse(response.body) rescue {}
    end    

    def get_contract_info_with_vehicles_by_name(name)
      raise ":::Unauthenticated:::" unless @auth
      endpoint = "#{@baseUrl}/?doctype=Contrato&name=#{CGI.escape(name)}&cmd=frappe.desk.form.load.getdoc"
      response = HTTParty.get(endpoint, headers: { 'Cookie' => @cookies } )
      JSON.parse(response.body) rescue {}
    end

    def get_contract_info_with_vehicles_by_document(document)
      contract = get_contract_by_document(document, ["name"])
      return nil if contract["data"].empty?
      contract_name = contract["data"][0]["name"]
      contract_info = get_contract_info_with_vehicles_by_name(contract_name)
      return nil unless contract_info["message"].nil?
      contract_info
    end

    def get_contracts_by_user(user, fields = ["*"])
      raise ":::Unauthenticated:::" unless @auth
      endpoint = "#{@baseUrl}/api/resource/Contrato?filters=[[\"customer_user\",\"=\",\"#{CGI.escape(user)}\"]]&fields=#{fields.to_s}"
      response = HTTParty.get(endpoint, headers: { 'Cookie' => @cookies } )
      data = JSON.parse(response.body) rescue {}
    end

    def get_contract_info_by_name(name)
      get_contract_info_with_vehicles_by_name(name)
    end

    def get_total_count_document_by_doctype(doctype)
      raise ":::Unauthenticated:::" unless @auth
      endpoint = "#{@baseUrl}/?doctype=#{doctype}&fields=[\"count(name)+AS+total_count\"]&cmd=frappe.desk.reportview.get"
      response = HTTParty.get(endpoint, headers: { 'Cookie' => @cookies } )
      data = JSON.parse(response.body) rescue {}
      { total_count: data["message"]["values"][0][0] }
    end

    def get_all_documents_by_doctype(doctype, fields = ["*"])
      raise ":::Unauthenticated:::" unless @auth
      total_count = get_total_count_document_by_doctype(doctype)
      endpoint = "#{@baseUrl}/api/resource/#{doctype}?fields=#{fields.to_s}&limit_start=0&limit_page_length=#{total_count["total_count"]}"
      response = HTTParty.get(endpoint, headers: { 'Cookie' => @cookies } )
      JSON.parse(response.body) rescue {}
    end

    def get_documents_by_doctype_and_filters(doctype, key, value, fields=['*'])
      raise ":::Unauthenticated:::" unless @auth
      endpoint = "#{@baseUrl}/api/resource/#{doctype}?filters=[[\"#{key}\",\"=\",\"#{CGI.escape(value)}\"]]&fields=#{fields.to_s}"
      response = HTTParty.get(endpoint, headers: { 'Cookie' => @cookies } )
      JSON.parse(response.body) rescue {}
    end

    def get_document_by_doctype_and_name(doctype, name)
      raise ":::Unauthenticated:::" unless @auth
      endpoint = "#{@baseUrl}/api/resource/#{doctype}/#{name}"
      response = HTTParty.get(endpoint, headers: { 'Cookie' => @cookies } )
      JSON.parse(response.body) rescue {}
    end

    def create_document(doctype, data = {})
      raise ":::Unauthenticated:::" unless @auth
      endpoint = "#{@baseUrl}/api/resource/#{doctype}"
      options = {
        headers: {
          'Cookie' => @cookies,
          'Content-Type' => 'application/json',
        },
        :body => data.to_json
      }
      response = HTTParty.post(endpoint, options)
      JSON.parse(response.body) rescue {}
    end

    def update_document(doctype, name, data = {})
      raise ":::Unauthenticated:::" unless @auth
      endpoint = "#{@baseUrl}/api/resource/#{doctype}/#{name}"
      options = {
        headers: {
          'Cookie' => @cookies,
          'Content-Type' => 'application/json',
        },
        :body => data.to_json
      }
      response = HTTParty.put(endpoint, options)
      JSON.parse(response.body) rescue {}
    end

    def delete_document(doctype, name)
      raise ":::Unauthenticated:::" unless @auth
      endpoint = "#{@baseUrl}/api/resource/#{doctype}/#{name}"
      options = {
        headers: {
          'Cookie' => @cookies,
          'Content-Type' => 'application/json',
        }
      }
      response = HTTParty.delete(endpoint, options)
      JSON.parse(response.body) rescue {}
    end

    private

    def parse_cookies(response)
      cookie_hash = HTTParty::CookieHash.new
      response.get_fields("Set-Cookie").each { |c| cookie_hash.add_cookies(c) }
      @cookies = cookie_hash.to_cookie_string
    end
  end
end
