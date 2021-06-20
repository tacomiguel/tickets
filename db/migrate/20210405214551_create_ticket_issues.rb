class CreateTicketIssues < ActiveRecord::Migration[5.2]
  def change
    create_table :ticket_issues do |t|
      t.string :issue_id
      t.string :cliente
      t.string :cliente_id
      t.string :imei
      t.references :ticket
      t.timestamps
    end
  end
end
