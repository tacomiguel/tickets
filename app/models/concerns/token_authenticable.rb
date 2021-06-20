module TokenAuthenticable
  extend ActiveSupport::Concern

  included do
    private :generate_unique_access_token

    before_save :ensure_access_token
  end

  def ensure_access_token
    return
    generate_access_token if ENV['AUTOMATIC_USER_TOKEN'].to_s == true && access_token.blank?
  end

  def generate_access_token(expires_in: 1.month)
    self.access_token = generate_unique_access_token
    self.access_token_expires_at = Time.zone.now + expires_in
  end

  def generate_unique_access_token
    loop do
      token = SecureRandom.hex
      # token = SecureRandom.base58(64)
      break token unless self.class.exists?(access_token: token)
    end
  end

  module ClassMethods
  end
end
