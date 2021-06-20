module Geo
  module Utils
    module ModelCallbacks
      extend ActiveSupport::Concern
    
      FIELD_BLACKLIST = ["id", "created_at", "updated_at"]
      # FIELD_BLACKLIST = ["id", "encrypted_password", "created_at", "updated_at"]
    
      included do
        class_attribute :replicator_callbacks
        class_attribute :replicator_conditions
        class_attribute :replicator_use_past_attributes_for_conditions
        class_attribute :replicator_fields
        
        self.replicator_callbacks = [:create, :update, :soft_delete, :destroy]
        self.replicator_conditions = nil
        self.replicator_use_past_attributes_for_conditions = true
        self.replicator_fields = nil
    
        after_validation :replicator_after_validation_callback
        after_commit :replicator_after_create_commit_callback, on: :create
        after_commit :replicator_after_update_commit_callback, on: :update
        after_commit :replicator_after_destroy_commit_callback, on: :destroy
      end
    
      def replicator_after_validation_callback
        if self.class.replicator_use_past_attributes_for_conditions && replicator_conditions_allowed
          conditions_was
        end
        # @rs_fields_hidden ||= {}
        # if self.respond_to?(:password)
        #   @rs_fields_hidden["password"] = self.password unless self.password.nil?
        # end
      end
    
      def replicator_after_create_commit_callback
        return unless callback_allowed?(:create)
        return unless replicator_conditions_allowed
        encrypted_message = Geo::Utils.encrypt(create_message(:create).to_json)
        Geo::Utils.replicator_request(ENV["REPLICATOR_UUID"], encrypted_message)
      end
    
      def replicator_after_update_commit_callback
        action = :update
        action = :soft_delete if self.respond_to?(:deleted?) && self.deleted?
        return unless callback_allowed?(action)
        return unless replicator_conditions_allowed
        encrypted_message = Geo::Utils.encrypt(create_message(action).to_json)
        Geo::Utils.replicator_request(ENV["REPLICATOR_UUID"], encrypted_message)
      end
    
      def replicator_after_destroy_commit_callback
        return unless callback_allowed?(:destroy)
        return unless replicator_conditions_allowed
        encrypted_message = Geo::Utils.encrypt(create_message(:destroy).to_json)
        Geo::Utils.replicator_request(ENV["REPLICATOR_UUID"], encrypted_message)
      end
    
      def create_message(callback, with_fields = false)
        message = {
          table: self.class.table_name.classify.pluralize,
          action: callback,
          conditions: conditions,
          expire: expiration_message_at
        }
        @rs_conditions = nil
        message[:fields] = fields if callback != :destroy && with_fields
        message
      end
    
      def expiration_message_at
        expiration_time = (ENV["REPLICATOR_EXPIRATION_TIME"] || 30).minutes
        (Time.zone.now + expiration_time).utc.to_i * 1000
      end
    
      def conditions
        @rs_conditions ||= replicator_conditions_allowed.map do |condition|
          { "#{condition}" => self[condition] }
        end
      end
    
      def conditions_was
        @rs_conditions ||= replicator_conditions_allowed.map do |condition|
          { "#{condition}" => self.attribute_was(condition) }
        end
      end
    
      def fields
        fs = {}
        if replicator_fields_allowed
          replicator_fields_allowed.each do |field|
            fs["#{field}"] = self[field]
          end
        else
          fs = self.attributes.except(*FIELD_BLACKLIST)
        end
        fs.merge(@rs_fields_hidden || {})
      end
    
      def replicator_fields_allowed
        @rs_fields_allowed ||= self.class.replicator_fields
      end
    
      def replicator_conditions_allowed
        @rs_conditions_allowed ||= self.class.replicator_conditions
      end
    
      def replicator_callbacks_allowed
        @rs_callbacks_allowed ||= self.class.replicator_callbacks.map(&:to_sym)
      end
    
      def callback_allowed?(callback)
        replicator_callbacks_allowed.include?(callback)
      end
    end
  end
end