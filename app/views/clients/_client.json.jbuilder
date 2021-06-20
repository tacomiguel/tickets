json.extract! client, :id, :email, :name, :phone, :client_type, :created_at, :updated_at
json.url client_url(client, format: :json)
