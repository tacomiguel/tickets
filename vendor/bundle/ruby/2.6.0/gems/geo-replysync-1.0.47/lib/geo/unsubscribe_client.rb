module Geo
  module Utils
    class UnsubscribeClient
      def initialize(data)
        @data = data
        process
      end

      def self.execute(data)
        UnsubscribeClient.new(data)
      end

      def process
        @api = Gnext::Api.new(ENV["ERP_API_URL"].to_s, ENV["ERP_USER"].to_s, ENV["ERP_PASSWORD"].to_s)
        @whitelist = YAML.load_file("#{Rails.root}/config/replysync.whitelist.yml").with_indifferent_access
        @whitelist_client = @whitelist[:Tables][:Clients]
        @whitelist_vehicle = @whitelist[:Tables][:Vehicles]

        if @data["management"] == "BAJA DE CONTRATO"
          procces_by_contract
        elsif @data["management"] == "BAJA DE USUARIO Y SUS CONTRATOS"
          procces_by_username
        end
        @api.logout
      end

      def procces_by_contract
        contract_info = @api.get_contract_info_by_name(@data["contract_code"])["docs"].first rescue {}
        return if contract_info.empty?

        document = ""
        business_user = contract_info["business_user"]
        customer_user = contract_info["customer_user"]
        if business_user && business_user == customer_user
          document = contract_info["business_document"]
        else
          document = contract_info["customer_code"]
        end

        client = Client.find_by(document: document)
        return if client.nil?

        vehicles = []
        if business_user
          vehicle_imeis = get_vehicles_of_contract(contract_info).map { |v| v["imei"] }
          vehicles = client.vehicles.where(imei: vehicle_imeis)
        else
          vehicles = client.vehicles
        end

        deleted_at_column = @whitelist_vehicle[:fields].key "deleted_at"
        vehicles.each do |vehicle|
          if @whitelist_vehicle[:atx]
            vehicle.update(enabled_status: 0)
          else
            vehicle.update("#{deleted_at_column}": Time.zone.now)
          end
        end

        if @whitelist_vehicle[:atx]
          if client.vehicles.where(enabled_status: 1).count == 0
            client.update(enabled_status: 0)
          end
        else
          if client.vehicles.where("#{deleted_at_column}": nil).count == 0
            deleted_at_column = @whitelist_client[:fields].key "deleted_at"
            client.update("#{deleted_at_column}": Time.zone.now)
          end
        end
      end

      def procces_by_username
        company_client = @api.get_company_customer_by_user(@data["customer_user"])["data"].first rescue {}
        return if company_client.empty?

        clients = []

        sub_clients = @api.get_sub_customers_by_company_client_name(company_client["name"])["data"] rescue []
        sub_clients.each do |sub_client|
          if sub_client["customer_user"] != company_client["customer_user"]
            clients << {
              "document" => sub_client["customer_code"],
              "panel_user" => sub_client["customer_user"]
            }
          end
        end

        clients << {
          "document" => company_client["customer_code"],
          "panel_user" => company_client["customer_user"]
        }

        clients.each do |client_data|
          client = Client.find_by(document: client_data["document"])
          next if client.nil?

          deleted_at_column = @whitelist_vehicle[:fields].key "deleted_at"
          client.vehicles.each do |vehicle|
            if @whitelist_vehicle[:atx]
              vehicle.update(enabled_status: 0)
            else
              vehicle.update("#{deleted_at_column}": Time.zone.now)
            end
          end

          if @whitelist_vehicle[:atx]
            client.update(enabled_status: 0)
          else
            deleted_at_column = @whitelist_client[:fields].key "deleted_at"
            client.update("#{deleted_at_column}": Time.zone.now)
          end
        end
      end

      def get_vehicles_of_contract(contract_info)
        vehicles_data = []

        contract_info["tb_vehicles"].each do |tb_veh|
          veh = {
            "imei" => tb_veh["vehicle_imei"].to_s.strip,
          }

          if @whitelist_vehicle[:atx]
            if tb_veh["gps_2"]
              veh["imei"] = tb_veh["gps_2"].to_s.strip
            else
              next
            end
          end

          vehicles_data << veh
        end
        
        contract_info["tb_annex_2"].each do |tb_veh|
          veh = {
            "imei" => tb_veh["vehicle_imei_anx2"].to_s.strip,
          }

          if @whitelist_vehicle[:atx]
            if tb_veh["gps_anx2_2"]
              veh["imei"] = tb_veh["gps_anx2_2"].to_s.strip
            else
              next
            end
          end

          vehicles_data << veh
        end

        vehicles_data
      end
    end
  end
end
