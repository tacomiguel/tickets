class CreateTicketReasons < ActiveRecord::Migration[5.2]
  def change
    create_table :ticket_reasons do |t|
      t.string :name
      t.integer :sort
      t.integer :default, null: false, limit: 1, :default => 0
      t.integer :status, null: false, limit: 1, :default => 1
      t.timestamps
    end
  end
end
