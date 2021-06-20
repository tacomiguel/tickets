class CreateQuestions < ActiveRecord::Migration[5.2]
  def change
    create_table :questions do |t|
      t.string :name
      t.string :campo
      t.timestamps
    end
  end
end
