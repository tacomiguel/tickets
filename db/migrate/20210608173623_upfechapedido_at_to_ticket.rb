class UpfechapedidoAtToTicket < ActiveRecord::Migration[5.2]
  def up
    change_column :tickets, :fechaticket, :date, :default => DateTime.now.strftime('%m/%d/%Y')
   
  end
end

