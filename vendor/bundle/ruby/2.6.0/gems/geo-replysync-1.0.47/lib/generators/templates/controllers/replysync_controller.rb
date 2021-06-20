class ReplysyncController < ApplicationController
  # Si no implementas un metodo de autentication por ejemplo authenticate_user!(Devise)
  # puedes comentar la siguiente linea

  skip_before_action :authenticate_user!
  skip_before_action :verify_authenticity_token

  def sync
    if ENV["X_GEO_APIKEY"]
      api_key = request.headers["X-GEO-APIKEY"]
      if api_key != ENV["X_GEO_APIKEY"]
        return render json: { message: "Invalid api key" }, status: :unauthorized
      end
    end
    
    SyncClientVehiclesJob.perform_later(get_panel_user)
    render json: { message: "processing request in the background" }
  end

  # dar de baja al cliente
  def unsubscribe_client
    if ENV["X_GEO_APIKEY"]
      api_key = request.headers["X-GEO-APIKEY"]
      if api_key != ENV["X_GEO_APIKEY"]
        return render json: { message: "Invalid api key" }, status: :unauthorized
      end
    end

    data = {
      "management" => params["management"],
      "contract_code" => params["contract_code"],
      "customer_user" => params["customer_user"],
    }
    UnsubscribeClientJob.perform_later(data)
    render json: { message: "processing request in the background" }
  end

  private

  def get_panel_user
    params[:client][:username]
  end
end
