module Geo
  module Utils
    def self.decrypt(encrypted_text)
      begin
        AES256.decrypt(encrypted_text, encryption_key)
      rescue => ex
        p "REPLYSYNC ERROR TO DECRYPT.............."
        p ex.message
        nil
      end
    end

    def self.encrypt(plaint_text)
      begin
        AES256.encrypt(plaint_text, encryption_key)
      rescue => ex
        p "REPLYSYNC ERROR TO ENCRYPT.............."
        p ex.message
        nil
      end
    end

    def self.replicator_request(uuid, body)
      return if body.nil?
      return if uuid.blank?
      return if replicator_url.blank?
      endpoint = "#{replicator_url}/listen/uuid/#{uuid}"
      begin
        send_request(endpoint, { message: body }.to_json)
      rescue => ex
        p "REPLYSYNC ERROR TO SEND REQUEST.............."
        p ex.message
      end
    end

    def self.send_request(endpoint, payload)
      retries = 3
      delay = 1
      begin
        headers = {"Content-Type" => "application/json" }
			  headers["X-GEO-APIKEY"] = ENV["X_GEO_APIKEY"] if ENV["X_GEO_APIKEY"]
        response = Faraday.post endpoint, payload, headers
      rescue Faraday::Error => err
        if retries == 0
          raise "All retries are exhausted"
        end
        retries -= 1
        sleep delay
        retry
      end
    end

    def self.encryption_key
      ENV["REPLICATOR_ENCRYPTION_KEY"]
    end

    def self.replicator_url
      ENV["REPLICATOR_URL"]
    end
  end
end
