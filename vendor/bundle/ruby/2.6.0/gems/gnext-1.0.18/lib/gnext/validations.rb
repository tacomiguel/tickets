# frozen_string_literal: true

module Gnext
  module Validations

    ACCEPTED_VALUES_DATA_TYPES = [NilClass, TrueClass, Integer, Float, String, Symbol].freeze
    ACCEPTED_FIELDS_DATA_TYPES = [String, Symbol].freeze
    ACCEPTED_OPERATORS_DATA_TYPES = [String, Symbol].freeze

    def check_if_method_has_arguments!(method_name, args, message = nil)
      if args.blank?
        raise ArgumentError, message || "The method .#{method_name}() must contain arguments."
      elsif block_given?
        yield args
      else
        args.flatten!
        compact_blank!(args)
      end
    end

    def check_if_has_arguments_valid!(arg_klass, args, message = nil)
      message = message || 'The arguments passed is wrong.'

      if arg_klass == Array
        data = args
        if args[0] == Array
          raise ArgumentError, message if args.size > 1
          data = args[0]
          raise ArgumentError, message if args[0].size != 3
        end
        raise ArgumentError, message unless ACCEPTED_FIELDS_DATA_TYPES.include?(data[0].class)
        raise ArgumentError, message unless ACCEPTED_OPERATORS_DATA_TYPES.include?(data[1].class)
        raise ArgumentError, message unless ACCEPTED_VALUES_DATA_TYPES.include?(data[2].class)
        if data[2] == Array
          data[2].each do |opt|
            raise ArgumentError, message unless ACCEPTED_VALUES_DATA_TYPES.include?(value.class)
          end
        end
      end

      if arg_klass == Hash
        raise ArgumentError, message if args.size > 1
        args.first.each do |key, value|
          raise ArgumentError, message unless ACCEPTED_FIELDS_DATA_TYPES.include?(key.class)
          raise ArgumentError, message unless ACCEPTED_VALUES_DATA_TYPES.include?(value.class)
          if value == Array
            value.each do |opt|
              raise ArgumentError, message unless ACCEPTED_VALUES_DATA_TYPES.include?(value.class)
            end
          end
        end
      end
    end

    def check_if_update_method_has_arguments_valid!(args)
      if args.size > 2
        raise ArgumentError, "Wrong number of arguments (given #{args.size}, max expected 2)."
      end

      name = nil
      data = nil

      if args.size == 1
        data = args.first
        raise ArgumentError, "The body argument must be hash." if data.class != Hash
      else
        name = args.first
        data = args.last
        raise ArgumentError, "The name argument must be String." if name.class != String
        raise ArgumentError, "The body argument must be hash." if data.class != Hash
      end

      data = JSON.parse(data.to_json, symbolize_names: true) rescue {}
      [name, data]
    end

    private

    def compact_blank!(args)
      if args.respond_to?(:compact_blank!)
        args.compact_blank!
        return
      end

      case args
      when Array
        args.delete_if { |v| v.blank? }
      when Hash
        args.delete_if { |_k, v| v.blank? }
      end
    end

  end
end
