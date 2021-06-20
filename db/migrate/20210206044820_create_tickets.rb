class CreateTickets < ActiveRecord::Migration[5.2]
  def change
    create_table :tickets do |t|
      t.uuid
      t.string     :title
      t.references :client
      t.references :ticket_priority
      t.references :ticket_status
      t.references :ticket_source
      t.references :departament
    
      t.references :assigned_user
      t.datetime :assigned_at

      t.datetime :closed_at
      t.datetime :reopened_at

      # Este campo solo esta para saber quien lo ha creado
      t.references :creator, null: false, polymorphic: true

      t.timestamps
    end
  end
end
