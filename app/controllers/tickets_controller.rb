class TicketsController < ApplicationController
  before_action :set_ticket, only: %i[ show edit update mail]

  # GET /tickets or /tickets.json
  def index
    
    # id_dep = current_user&.departament_id
    # params[:departament_id] = id_dep
    #render plain: params.inspect
    @tickets = Ticket.search_tickets(params)
    #@tickets = Ticket.all
    @pagy, @tickets = pagy(@tickets)
  end

 
  # GET /tickets/1 or /tickets/1.json
  def show
    
    @ticket_thread = TicketThread.new
    #habilita cambio de estado para el usuario asignado al ticket
    current_user&.id  != @ticket.assigned_user_id or @ticket.ticket_status_id == 2 ? @habilita_estado = false : @habilita_estado = true
    #habilita cambio de datos slo si esta abieto ticket

    @ticket.ticket_status_id == 2 ? @habilita_datos = false : @habilita_datos = true
    #el si se cieera el estado del ticket nl podran cambiar nada
    @ticket.ticket_status_id == 2 ? @habilita_estado_save = false : @habilita_estado_save = true
    
    #para ubicar el nombre del departamento que pertenece el usuario
    id_dep = @ticket.assigned_user&.departament_id
    id_dep.nil? ? @dep="" :  @dep=Departament.select("name").find(id_dep).name
  end

  # GET /tickets/new
  def new
    @ticket = Ticket.new
    @ticket.ticket_threads.build
    @ticket.build_client
  end

  # GET /tickets/1/edit
  def edit
  end

  # POST /tickets or /tickets.json
  def create
    @ticket = Ticket.new(ticket_params.merge(creator: current_user))

    respond_to do |format|
      if @ticket.save
        TicketSendMailer.send_signup_email(@ticket).deliver_now
        format.html { redirect_to @ticket, notice: "Ticket was successfully created." }
        format.json { render :show, status: :created, location: @ticket }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @ticket.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tickets/1 or /tickets/1.json
  def update
    respond_to do |format|
      if @ticket.update(ticket_params)
        
        @ticket.bitacora(current_user&.id,current_user&.name)
        format.html { redirect_to @ticket, notice: "Ticket was successfully updated." }
        format.json { render :show, status: :ok, location: @ticket }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @ticket.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_ticket
    @ticket = Ticket.find(params[:id])
    #render plain: @ticket.inspect
  end

  def ticket_params
    params.require(:ticket).permit(:title, :client_id, :ticket_priority_id, :ticket_status_id, :ticket_source_id, :ticket_reason_id, :departament_id, :assigned_user_id, :client_source, :referencia_id, :fechaticket,
                                   ticket_threads_attributes: [:body, :thread_type, attachments: []],
                                   client_attributes: [:name, :email, :phone])
  end
end
