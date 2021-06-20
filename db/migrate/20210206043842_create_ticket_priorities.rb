class CreateTicketPriorities < ActiveRecord::Migration[5.2]
  def change
    create_table :ticket_priorities do |t|
      t.string :name
      t.string :color, limit: 10
      t.integer :priority, limit: 1, null: false, :default => 0
      t.integer :status, limit: 1, null: false, :default => 1

      t.timestamps
    end
  end
end
