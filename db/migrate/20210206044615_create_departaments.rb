class CreateDepartaments < ActiveRecord::Migration[5.2]
  def change
    create_table :departaments do |t|
     
      t.string :name
      t.integer :status, null: false, limit: 1, :default => 1

      t.timestamps
    end
  end
end
