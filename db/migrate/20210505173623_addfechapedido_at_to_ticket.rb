class AddfechapedidoAtToTicket < ActiveRecord::Migration[5.2]
  def change
    add_column :tickets, :fechaticket, :date
   
  end
end
