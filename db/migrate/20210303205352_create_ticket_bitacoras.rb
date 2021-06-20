class CreateTicketBitacoras < ActiveRecord::Migration[5.2]
  def change
    create_table :ticket_bitacoras do |t|
      t.bigint  :modelo_id
      t.string  :modelo
      t.string  :campo
      t.string  :valor
      t.string  :valor_actual
      t.string  :verbo
      t.string  :user
      t.timestamps
    end
  end
end
