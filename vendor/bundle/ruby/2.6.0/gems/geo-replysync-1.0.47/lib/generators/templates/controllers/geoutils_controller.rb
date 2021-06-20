class GeoutilsController < ApplicationController
  # Si no implementas un metodo de autentication por ejemplo authenticate_user!(Devise)
  # puedes comentar la siguiente linea

  skip_before_action :authenticate_user!
  skip_before_action :verify_authenticity_token
  
  def sync
    body = Geo::Utils.decrypt(params[:message])
    data = JSON.parse(body).with_indifferent_access

    if ENV["X_GEO_APIKEY"]
      api_key = request.headers["X-GEO-APIKEY"]
      if api_key != ENV["X_GEO_APIKEY"]
        render json: { message: "Invalid api key" }, status: :unauthorized
        return
      end
    end

    expires = Time.zone.at(data[:expire].to_i / 1000)
    if expires < Time.zone.now
      render json: { message: "request has expired" }, status: :forbidden
      return
    end

    klass = data[:table].singularize.constantize

    if klass == User
      SyncUserTagsJob.perform_later(data)
      render json: { message: "processing request in the background" }
      return
    end

    sql_statement = data[:conditions].map { |c| "#{c.keys.first} = ?" }.join(" AND ")
    values_statement = data[:conditions].map { |c| c.values.first }

    if data[:action] == "destroy"
      instance = klass.where(sql_statement, values_statement).first
      instance.destroy if instance
      render json: { message: "processed request", record: instance, record_type: instance.class.name }
    else
      whitelist = YAML.load_file("#{Rails.root}/config/geo.utils.whitelist.yml").with_indifferent_access
      model_whitelist = whitelist[:Tables][data[:table]]

      instance = klass.where(sql_statement, values_statement).first_or_initialize
      model_whitelist[:fields].each do |field|
        next if data[:fields][field].nil?
        # instance.send("#{field}=", data[:fields][field])
        instance[field] = data[:fields][field]
      end

      if instance.save
        render json: { message: "request processed", record: instance, record_type: instance.class.name }
      else
        render json: { message: "request faied", errors: instance.errors, record: instance, record_type: instance.class.name }, status: :unprocessable_entity
      end
    end
  end
end
