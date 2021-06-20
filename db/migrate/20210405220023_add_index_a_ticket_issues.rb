class AddIndexATicketIssues < ActiveRecord::Migration[5.2]
  def change
    add_index :ticket_issues, :imei
  end
end
