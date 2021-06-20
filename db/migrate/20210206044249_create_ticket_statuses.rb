class CreateTicketStatuses < ActiveRecord::Migration[5.2]
  def change
    create_table :ticket_statuses do |t|
      t.string :name
      t.integer :sort
      t.integer :default, null: false, limit: 1, :default => 0
      t.integer :status, null: false, limit: 1, :default => 1
      t.integer :system_status, null: false, limit: 1, :default => 0

      t.timestamps
    end
  end
end
