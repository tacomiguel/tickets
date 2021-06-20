class CreateClients < ActiveRecord::Migration[5.2]
  def change
    create_table :clients do |t|
      t.string :email
      t.string :name
      t.string :phone, limit: 15
      t.integer :client_type, limit: 1, null: false, :default => 1

      t.timestamps
    end
  end
end
