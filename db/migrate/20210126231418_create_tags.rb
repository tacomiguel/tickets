class CreateTags < ActiveRecord::Migration[5.2]
  def change
    create_table :tags do |t|
      t.string :name
      t.boolean :active
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
