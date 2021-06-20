class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.translate_enum_name(enum_name, enum_value)
    I18n.t("activerecord.attributes.#{model_name.i18n_key}.#{enum_name.to_s.pluralize}.#{enum_value}")
  end

  def self.translate_enum_collection(enum_name)
    enum_values = self.send(enum_name.to_s.pluralize).keys
    enum_values.map do |enum_value|
      self.translate_enum_name enum_name, enum_value
    end
  end

  # In our views, we can then translate single values:
  # <p>User Status: <%= User.translate_enum_name :status, @user.status %></p>

  # Or the entire collection of enum values:
  # <%= f.select(:status, User.translate_enum_collection :status) %>
end
