class TicketPdf < Prawn::Document
  def initialize(data)
    super()
    @midata = data
    line_items
  
   end

  def line_items
    table line_items_rows
  end

  def line_items_rows
    [['id','asunto','cliente','prioridad','estatus','departamento','asignado']] +
     @midata.map do |r|
      [r.id, r.asunto,r.cliente,r.prioridad,r.estatus,r.departamento,r.asignado]
    end
  end
end

