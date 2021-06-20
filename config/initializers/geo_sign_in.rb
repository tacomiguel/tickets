require 'devise/strategies/authenticatable'

module Devise
  module Strategies
    class GeoSignIn < Authenticatable
      def authenticate!
        if params[:user]
          user = cas_remote_auth
          if user
            success!(user)
          else
            return fail(:invalid_login)
          end
        end
      end

      def email
        params[:user][:email]
      end

      def password
        params[:user][:password]
      end

      def cas_remote_auth
        user = nil
        url = ENV['CAS_URL'].to_s
        conn = Faraday.new(url: url) do |faraday|
          faraday.use Faraday::Request::UrlEncoded
          faraday.use Faraday::Response::Logger
          faraday.use Faraday::Adapter::NetHttp
        end
        begin
          message = {
            email: email,
            password: password,
            app_name: ENV['APP_NAME'].to_s
          }.to_json

          params_sign_in = {
            message: Geo::Utils.encrypt(message)
          }

          response = conn.post do |req|
            req.url  '/cas-company/api/user/sign_in'
            req.headers['X-GEO-APIKEY'] = ENV['X_GEO_APIKEY'].to_s
            req.body = params_sign_in
          end

          if response.success?
            if response.status == 200
              body = JSON.parse(response.body) rescue {}
              user = User.where(email: email.to_s).first_or_initialize
              user.password = email.to_s
              if !user.save
                p "<=USER SV ERRORS=======================>"
                p user.errors.full_messages
                p "<======================================>"
                user = nil
              else
                #asigna departamento al usuario
                user.update!(full_name: body['fullname'].to_s)
                user.assign_departament(body['profile'].to_s.upcase)
                #asigna departamento al usuario
                cas_tags_names = []
                tags = user.tags
                tag_system = {}
                tags.map { |tag| tag_system[tag.name] = tag }
                tags_list = body['tags_list'] || []
                tags_list.each do |cas_tag|
                  tag = tag_system[cas_tag['name']]
                  record = { name: cas_tag['name'], active: cas_tag['active'] }
                  if tag
                    tag.update(record)
                  else
                    tag = user.tags.create(record)
                  end
                  cas_tags_names << cas_tag['name']
                end
                user.tags.where.not(name: cas_tags_names).destroy_all
              end
            end
          end
        rescue Exception => e
          p "========================="
          p "Error during processing: #{$!}"
          p "Backtrace:\n\t#{e.backtrace.join("\n\t")}"
          p "========================="
        end
        user
      end
    end
  end
end

Warden::Strategies.add(:geo_sign_in, Devise::Strategies::GeoSignIn)
