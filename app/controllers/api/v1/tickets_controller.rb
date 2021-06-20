class Api::V1::TicketsController < Api::ApiController
  def index

    search = params[:q].to_s.strip
    origen = params[:app_name].to_s.strip

    field = 'ticket_issues.imei'
    case params[:q_by].to_s.strip
    when 'issue.id'
      field = 'ticket_issues.issue_id'
    when 'vehicle.imei'
      field = 'ticket_issues.imei'
    when 'client.document'
      field = 'ticket_issues.cliente_id'
    end

    if search.blank?
      var = ""
    else
      var = "and #{field}= #{search} "
    end

    query = " ticket_sources.name= '#{origen}' #{var} "

    pagy, tickets = pagy Ticket.includes(:ticket_status, :ticket_source, :ticket_issues).joins(:ticket_status, :ticket_source)
    .where(query)
    .select('
      tickets.id,
      tickets.title,
      tickets.created_at,
      tickets.fechaticket
    ')
    .distinct

    tickets = tickets.map do |ticket|
      issues = ticket.ticket_issues.map do |ti|
        { issue_id: ti.issue_id, imei: ti.imei }
      end

      {
        id: ticket.id,
        title: ticket.title,
        status: ticket.ticket_status.name,
        origen: ticket.ticket_source.name,
        created_at: ticket.created_at,
        fechaticket: ticket.fechaticket&.strftime("%d/%m/%Y"),
        issues: issues
      }
    end
    render json: { data: tickets, metadata: pagy_metadata(pagy).slice(:page, :prev, :next, :last, :pages) }
  end

  def show
    render json: { message: 'show'}
  end

  def update
    idIssue= TicketIssue.find_by(issue_id: params[:id]) #buscar codigo caso
    idticket=idIssue.ticket_id

    @ticket= Ticket.find_by(id: idticket)
    #@ticket.ticket_status_id='2' #estado ticket cerrado

    if @ticket.update_attributes(ticket_params)
        render json: {
            message: 'Actualizado',
            data: @ticket
        }, status: :ok
      else
        render json: {
          message: 'No Actualizado',
          data: @ticket
      }, status: :unprocessable_entity

      end
  end

  def create
    email = request.headers["X-GEO-TICKETCREATOR"].to_s
    creator_user = User.find_by(email: email)
    creator_user = User.create(email: email, password: SecureRandom.hex) if creator_user.nil?
   
    @ticket = Ticket.new(ticket_params.merge(creator: creator_user))
    @ticket.ticket_status = TicketStatus.find_by(default: 1)

    @ticket.assigned_user = User.find_by(name: "frodriguez")
    
    appname = request.headers["X-GEO-APPNAME"].to_s.upcase
    @ticket.ticket_source = TicketSource.find_or_create_by(name: appname)

    if @ticket.save
      issues_ids = params[:ticket][:relationships][:issues] rescue []

      if appname == "LIBRO"
        ticket_issue = @ticket.ticket_issues.find_or_initialize_by(issue_id: issues_ids)
        ticket_issue.save
      else
        AssignIssuesToTicketJob.perform_later(@ticket.id, issues_ids) unless issues_ids.empty?
      end

      ticket_data = {
        id: @ticket.id,
        uuid: @ticket.uuid,
        title: @ticket.title,
        status: @ticket.ticket_status&.name,
        priority: @ticket.ticket_priority&.name,
        assigned: @ticket.assigned_user&.name,
        fechaticket: @ticket.fechaticket.to_s
      }

      render json: { ticket_uuid: @ticket.uuid, ticket: ticket_data }, status: :created
    else
      ap  @ticket.errors
      render json: { errors: @ticket.errors.full_messages }, status: :unprocessable_entity
    end


  end

  def extend

    @ticket = Ticket.find(params[:id])
    issues_ids = params[:ticket][:relationships][:issues] rescue []
    AssignIssuesToTicketJob.perform_later(@ticket.id, issues_ids) unless issues_ids.empty?
    render json: { message: 'Extendiendo ticket' }, status: :accepted
  end

  private


  def ticket_params
    params.require(:ticket).permit(
      :title, :ticket_status_id, :fechaticket, :assigned_user_id,
      ticket_threads_attributes: [:body, :thread_type, attachments: []],
      client_attributes: [:name, :email, :phone]
    )
  end
end
