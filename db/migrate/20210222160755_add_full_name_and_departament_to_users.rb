class AddFullNameAndDepartamentToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :full_name, :string
    add_reference :users, :departament, foreign_key: true
  end
end
