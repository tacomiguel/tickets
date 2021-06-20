class CreateTicketQuesions < ActiveRecord::Migration[5.2]
  def change
    create_table :ticket_questions do |t|
      t.integer :rb_1
      t.integer :rb_2
      t.integer :rb_3
      t.integer :rb_4
      t.integer :rb_5
      t.string  :tx_1
      t.string  :tx_2
      t.references :ticket
      t.timestamps
    end
  end
end
