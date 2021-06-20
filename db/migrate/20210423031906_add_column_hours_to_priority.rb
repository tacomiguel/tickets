class AddColumnHoursToPriority < ActiveRecord::Migration[5.2]
  def change
    add_column :ticket_priorities, :alerthours, :integer, :default => 1
   
  end
end
