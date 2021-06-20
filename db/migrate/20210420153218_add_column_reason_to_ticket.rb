class AddColumnReasonToTicket < ActiveRecord::Migration[5.2]

  def change
    change_table :tickets do |t|
      t.references :ticket_reason
    end
  end
end
