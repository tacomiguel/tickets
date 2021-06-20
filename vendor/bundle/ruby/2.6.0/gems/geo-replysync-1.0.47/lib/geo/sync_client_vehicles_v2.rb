module Geo
  module Utils
    def self.class_exists?(class_name)
      klass = Module.const_get(class_name)
      return klass.is_a?(Class)
    rescue NameError
      return false
    end

    class SyncClientVehiclesV2
      def self.sync(client_management_doc_name)
        api = Gnext::Api.new(ENV['ERP_API_URL'].to_s, ENV['ERP_USER'].to_s, ENV['ERP_PASSWORD'].to_s)
        client_management_info = api.get_document_by_doctype_and_name('Gestiones%20Cliente', client_management_doc_name.to_s).to_h['data'] rescue {}

        if client_management_info.nil? || client_management_info.empty?
          api.logout
          return { status: :not_found, message: "El documento [#{client_management_doc_name}] no fue encontrado" }
        end
        whitelist = YAML.load_file("#{Rails.root}/config/replysync.whitelist.yml").with_indifferent_access
        whitelist_client = whitelist[:Tables][:Clients]
        whitelist_vehicle = whitelist[:Tables][:Vehicles]

        client_data = {}
        vehicles_data = []
        unvalidated_contracts = 0
        ignore_atx = whitelist_vehicle[:ignore_atx] || false

        business_user = client_management_info["business_user"]
        customer_user = client_management_info["customer_user"]
        if business_user && business_user == customer_user
          client_data["document"] = client_management_info["business_document"]
          client_data["name"] = client_management_info["business_name"]
          client_data["panel_user"] = business_user
        else
          client_data["document"] = client_management_info["customer_document"]
          client_data["name"] = client_management_info["customer_name"]
          client_data["panel_user"] = customer_user
        end

        client_management_info['tb_contracts'].to_a.each_with_index do |contract_info, index|
          next if contract_info.empty?

          veh = {
            "imei" => contract_info["gps_imei"].to_s.strip,
            "plate" => contract_info["vehicle_plate"].to_s.strip,
            "name" => contract_info["vehicle_plate"].to_s.strip,
            "phone" => contract_info["gsm_number"].to_s.strip,
            "code" => contract_info["vehicle_code"].to_s.strip,
            "vehicle_type" => contract_info["vehicle_type"].to_s.strip.downcase,
            "deleted_at" => nil,
            "enabled_status" => 1,
            "secondary_device" => nil
          }

          if ignore_atx
            brand_name = contract_info["brand_name"].to_s.strip
            next if !brand_name.blank? && brand_name["CONCOX AT"]
          end


          if whitelist_vehicle[:atx] && contract_info["brand_name"].to_s.include?('CONCOX AT')
            veh["imei"] = contract_info["gps_imei"].to_s.strip
            veh["phone"] = contract_info["gsm_number"].to_s.strip
            veh["brand"] = contract_info["brand_name"].to_s.strip

            veh["secondary_device"] = {
              "imei" => contract_info["gps_imei"].to_s.strip,
              "phone" => contract_info["gsm_number"].to_s.strip,
              "brand" => contract_info["brand_name"].to_s.strip
            }
          end
          vehicles_data << veh
        end

        ap client_data
        ap vehicles_data

        begin
          ActiveRecord::Base.transaction do
            sql_statement = whitelist_client[:ids].map { |id| "#{id} = ?" }.join(' AND ')
            values_statement = []
            whitelist_client[:ids].each do |id|
              endpoint_field = whitelist_client[:fields][id]
              endpoint_field_value = client_data[endpoint_field]
              if endpoint_field_value
                values_statement << endpoint_field_value.to_s.strip  
              else
                raise ActiveRecord::Rollback, "undefined field id #{endpoint_field} in erp data"
              end
            end
            
            client = Client.where(sql_statement, values_statement).first_or_initialize
            whitelist_client[:fields].each do |app_field, endpoint_field|
              endpoint_field_value = client_data[endpoint_field]
              client[app_field] = endpoint_field_value.to_s.strip if endpoint_field_value
            end

            if whitelist_vehicle[:atx]
              client.enabled_status = 1
            else
              client.deleted_at = nil if client.respond_to?(:deleted_at)
            end
            
            new_client = client.new_record?
            client.save!

            delete_vehicles = whitelist_vehicle[:delete]
            case delete_vehicles
            when 'soft'
              if whitelist_vehicle[:fields].values.include? "deleted_at"
                vehicle_imeis = vehicles_data.map { |v| v["imei"] }
                vehicles_to_soft_delete = client.vehicles.where.not(imei: vehicle_imeis)
                deleted_at_column = whitelist_vehicle[:fields].key "deleted_at"
                vehicles_to_soft_delete.each do |vehicle|
                  vehicle.update("#{deleted_at_column}": Time.zone.now)
                end
              end
            when 'physical'
              vehicle_imeis = vehicle_data.map { |v| v["imei"] }
              vehicles_to_physical_delete = client.vehicles.where.not(imei: vehicle_imeis)
              vehicles_to_physical_delete.destroy_all
            end

            vehicles_data.each do |vehicle|
              vehicle["client_id"] = client.id
            end

            # SOLO PARA ATX
            if whitelist_vehicle[:atx] && !new_client
              client.vehicles.each do |vehicle|
                vehicle.update(enabled_status: 0)
              end
            end

            sql_statement = whitelist_vehicle[:ids].map { |id| "#{id} = ?" }.join(' AND ')
            vehicles_data.each do |vehicle_data|
              # SOLO PARA ATX
              if whitelist_vehicle[:atx]
                next if vehicle_data["secondary_device"].nil?
                next if vehicle_data["brand"].nil? || !vehicle_data["brand"]["CONCOX AT"]
              end

              if ignore_atx
                next if vehicle_data["brand"] && vehicle_data["brand"]["CONCOX AT"]
              end

              values_statement = []
              whitelist_vehicle[:ids].each do |id|
                endpoint_field = whitelist_vehicle[:fields][id]
                endpoint_field_value = vehicle_data[endpoint_field]
                if endpoint_field_value
                  values_statement << endpoint_field_value.to_s.strip
                else
                  raise ActiveRecord::Rollback, "undefined field #{endpoint_field} in erp data"
                end
              end
    
              vehicle = Vehicle.where(sql_statement, values_statement).first_or_initialize
              whitelist_vehicle[:fields].each do |app_field, endpoint_field|
                begin
                  endpoint_field_value = vehicle_data.fetch(endpoint_field)
                  endpoint_field_value = endpoint_field_value.to_s.strip if endpoint_field_value.class == String
                  vehicle[app_field] = endpoint_field_value
                rescue => e
                  p "-----------------------"
                  p e.message
                  p "-----------------------"
                  next
                end
              end

              if !vehicle_data["vehicle_type"].blank? && Geo::Utils.class_exists?('VehicleType')
                vt = VehicleType.find_by(name: vehicle_data["vehicle_type"])
                if !vt
                  vt = VehicleType.create(name: vehicle_data["vehicle_type"])
                end
                vehicle.vehicle_type_id = vt.id
              end

              vehicle.save!
            end
          end

          api.logout
          message = vehicles_data.empty? ? 'El usuario del cliente ha sido sincronizado pero no tiene vehículos'
                                         : 'El usuario del cliente ha sido sincronizado'
          if unvalidated_contracts > 0
            message += ", y tiene #{unvalidated_contracts} contrato#{unvalidated_contracts == 1 ? '' : 's'} sin validar"
          end
          return { status: :ok, message: message }
        rescue => e
          p "====================================================================="
          p "ERROR DURING PROCESSING"
          p "Backtrace: #{e.message}"
          e.backtrace.each { |b| p b }
          p "====================================================================="
          api.logout
          raise e.message
        end
      end
    end
  end
end
