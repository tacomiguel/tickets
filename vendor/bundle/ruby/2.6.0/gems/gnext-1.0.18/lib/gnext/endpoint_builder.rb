# frozen_string_literal: true

require 'gnext/validations'

module Gnext
  class EndpointBuilder
    include Gnext::Validations

    def initialize(doctype_name, client)
      @client            = client
      @doctype_name      = doctype_name
      @fields            = []
      @filters           = {}
      @limit_start       = 0
      @limit_page_length = 0
      @order_by          = nil
    end

    def select(*fields)
      check_if_method_has_arguments!(:select, fields, 'Call the method .select() with at least one field.')
      @fields |= fields
      self
    end

    def where(*args)
      check_if_method_has_arguments!(:where, args) do
        raise ArgumentError, "Wrong number of arguments (given #{args.size}, max expected 3)." if args.size > 3
  
        if args.size == 3
          build_filter(Array, args)
        else
          klass = args.first.class
          if [Array, Hash].include?(klass)
            build_filter(klass, args)
          else
            raise ArgumentError, 'The arguments passed is wrong.'
          end
        end
      end
      self
    end

    def clean_conditions
      @filters = {}
      self
    end

    def offset(value)
      @limit_start = value.to_i
      self
    end

    def limit(value)
      @limit_page_length = value.to_i
      self
    end

    def order(*args)
      check_if_method_has_arguments!(:order, args) do
        args = args.first
        case args
        when String
          @order_by = args
        when Hash
          @order_by = args.map do |field, sort_by|
            "#{field} #{sort_by}"
          end.join(', ')
        else
          raise ArgumentError, 'The argument passed is wrong.'
        end
      end
      self
    end

    # METODOS FINALES
    def find(name)
      response = client.connection.get("/api/resource/#{doctype}/#{name}")
      response.body[:data]
    end

    def find_by(field, value)
      args = [{"#{field}": value}]
      check_if_has_arguments_valid!(Hash, args)
      build_filter(Hash, args)

      response = client.connection.get("/api/resource/#{doctype}") do |req|
        req.params = build_params
      end
      response.body[:data].first
    end

    def create(data)
      response = client.connection.post("/api/resource/#{doctype}") do |req|
        req.body = JSON.dump(data)
      end
      response.body[:data]
    end

    def update(*args)
      if args.blank?
        raise ArgumentError, 'Call the method .update() with at least one argument.'
      end

      name, data = check_if_update_method_has_arguments_valid!(args)
      name = name || data[:name]
      raise ArgumentError, "The name (ID) of the document is missing." if name.blank?

      response = client.connection.put("/api/resource/#{doctype}/#{name}") do |req|
        req.body = JSON.dump(data)
      end
      response.body[:data]
    end

    def delete(name)
      client.connection.delete("/api/resource/#{doctype}/#{name}")
    end

    def call(method)
      raise NotImplementedError
    end

    def list
      response = client.connection.get("/api/resource/#{doctype}") do |req|
        req.params = build_params
      end
      response.body[:data]
    end
    alias_method :list_all, :list

    def first_doc
      body = offset(0).limit(1).list
      body = body.first if body.class == Array
      body
    end

    def list_each(batch_size: 500)
      raise 'Need a block' unless block_given?
  
      list_in_batches(batch_size: batch_size) do |records|
        records.each do |record|
          yield record
        end
      end
    end
  
    def list_in_batches(batch_size: 500)
      raise 'Need a block' unless block_given?

      of = @limit_start.to_i
      loop do
        records = offset(of).limit(batch_size).list
        yield records
        break if records.size < batch_size
        of = of + batch_size
      end
    end

    private

    def client
      @client
    end

    def build_filter(arg_klass, args)
      check_if_has_arguments_valid!(arg_klass, args)

      if arg_klass == Array
        args = args.size == 3 ? args : args[0]
        @filters[args[0].to_s] = [args[1], args[2]]
      end

      if arg_klass == Hash
        args.first.each do |key, value|
          operator = '='
          operator = 'in' if value.class == Array
          @filters[key.to_s] = [operator, value]
        end
      end

      # if arg_klass == String
      # end
    end

    def doctype
      URI.escape(@doctype_name)
    end

    def build_params
      params = {}
      params[:fields] = JSON.dump(@fields) if !@fields.empty?
      if !@filters.empty?
        filters = []
        @filters.each do |k, v|
          filters << [k] + v
        end
        params[:filters] = JSON.dump(filters)
      end
      params[:limit_start] = @limit_start
      params[:limit_page_length] = @limit_page_length if @limit_page_length > 0
      params[:order_by] = @order_by unless @order_by.blank?
      params
    end
  end
end
