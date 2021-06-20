module Geo
  module Utils
    class SyncUserTags
      def self.sync(data)
        return if geo_cas_url.nil?

        sql_statement = data[:conditions].map { |c| "#{c.keys.first} = ?" }.join(" AND ")
        values_statement = data[:conditions].map { |c| c.values.first }
        user = User.where(sql_statement, values_statement).first

        if data[:action] == "destroy"
          user.soft_delete if user
        elsif data[:action] == "soft_delete"
          user.soft_delete if user
        elsif data[:action] == "create" || data[:action] == "update"
          auth_params={}
          auth_params[:email] = user ? user.email : data[:conditions].first[:email]
          auth_params[:app_name] = ENV["APP_NAME"].to_s
          auth_params[:user_exists_in_app] = user ? user.persisted? : false
          
          headers = {}
          headers["X-GEO-APIKEY"] = ENV["X_GEO_APIKEY"] if ENV["X_GEO_APIKEY"]

          endpoint = "#{geo_cas_url}/user/tags"
          retries = 3
          delay = 1
          begin
            response = Faraday.post endpoint, auth_params, headers
            if response.status == 200
              body = JSON.parse(response.body) rescue {}
              user_tags_data = JSON.parse(Geo::Utils.decrypt(body["message"])).with_indifferent_access

              # sql_statement = user_tags_data[:conditions].map { |c| "#{c.keys.first} = ?" }.join(" AND ")
              # values_statement = user_tags_data[:conditions].map { |c| c.values.first }
              user = User.find_or_initialize_by(email: user_tags_data[:conditions].first[:email])

              whitelist = YAML.load_file("#{Rails.root}/config/geo.utils.whitelist.yml").with_indifferent_access
              model_whitelist = whitelist[:Tables][user_tags_data[:table]]

              model_whitelist[:fields].each do |field|
                next if user_tags_data[:fields][field].nil?
                user[field] = user_tags_data[:fields][field]
              end

              if user.new_record?
                pass = SecureRandom.hex(6)
                user.password = pass
                user.password_confirmation = pass
              end

              if user.save
                p "-----------"
                p user
                p user_tags_data["tags"]
                p "-----------"
                user.update(encrypted_password: user_tags_data[:fields][:encrypted_password]) if user_tags_data[:fields][:encrypted_password]
                cas_tags_names = []
                tags = user.tags
                tag_system = {}
                tags.map { |tag| tag_system[tag.name] = tag }
                tags_list = user_tags_data["tags"] || []
                tags_list.each do |cas_tag|
                  tag = tag_system[cas_tag["name"]]
                  record = { name: cas_tag["name"], active: cas_tag["active"] }
                  if tag
                    tag.update(record)
                  else
                    tag = user.tags.create(record)
                  end
                  cas_tags_names << cas_tag["name"]
                end
                unverified_tags = user.tags.where.not(name: cas_tags_names)
                unverified_tags.map { |tag|  tag.destroy }
              else
                p "#########################"
                p user.errors
                p "#########################"
              end
            end
          rescue Faraday::Error => err
            if retries == 0
              raise "All retries are exhausted"
            end
            retries -= 1
            sleep delay
            retry
          end
        end
      end

      private

      def self.geo_cas_url
        ENV["CAS_URL"]
      end
    end
  end
end
