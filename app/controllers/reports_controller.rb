class ReportsController < ApplicationController
  before_action :set_query, only: [:index,:show]
  def show
    #render plain: params.inspect
  end

  def index
   
  end
     
  def set_query

    @data = Ticket.joins([assigned_user: :departament],:ticket_status).group("ticket_statuses.name","departaments.name").count

    sql= ("
    select t.id, t.title as asunto ,c.name as cliente,p.name as prioridad,
    s.name as estatus ,'' as departamento, u.name as asignado, us.name as creado,
    t.created_at as fec_inicio, d.name as departamento
    from tickets t 
    inner join clients c on c.id=t.client_id 
    left join ticket_priorities p on p.id=t.ticket_priority_id
    left join ticket_statuses s on s.id=t.ticket_status_id
    left join users u on u.id = t.assigned_user_id
    inner join users us on us.id = t.creator_id
    left join departaments d on d.id = u.departament_id
    where t.id>=1
     " )
     if params[:title].present?
      sql = sql + " and title like '%#{params[:title]}%' "
    end
    if params[:cliente_id].present?
      sql = sql + " and client_id='#{ params[:cliente_id]}' "
    end
    if params[:status_id].present?
      sql = sql + " and ticket_status_id='#{ params[:status_id]}' "
    end
    if params[:priority_id].present?
      sql = sql + " and ticket_priority_id='#{ params[:priority_id]}' "
    end
    if params[:asigned_user_id].present?
      sql = sql + " and assigned_user_id='#{ params[:asigned_user_id]}' "
    end
    sql = sql + "order by t.id, s.name "

    @report_data=Ticket.find_by_sql(sql)
    
    #render plain: h.inspect
    #@pagy, @report_data = pagy(@report_data)
    
  
    respond_to do |format|
      format.html
      format.xlsx
      format.pdf do
       pdf = TicketPdf.new(@report_data)
       send_data pdf.render,
       filename: "index.pdf",
       type: 'application/pdf',
       disposition: 'inline'
      end
    end
  end



end