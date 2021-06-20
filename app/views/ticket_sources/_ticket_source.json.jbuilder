json.extract! ticket_source, :id, :name, :created_at, :updated_at
json.url ticket_source_url(ticket_source, format: :json)
