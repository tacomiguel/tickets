class Ticket < ApplicationRecord
  uuidable
  has_many   :ticket_threads, dependent: :destroy
  has_many   :ticket_issues, dependent: :destroy

  belongs_to :client
  belongs_to :ticket_priority, optional: true
  belongs_to :ticket_status
  belongs_to :ticket_source
  belongs_to :ticket_reason, optional: true
  belongs_to :departament, optional: true
  belongs_to :creator, polymorphic: true
  belongs_to :assigned_user, class_name: 'User', foreign_key: 'assigned_user_id', optional: true

  attr_accessor :client_source
  validates :title, presence: true
  scope :select_options, -> { order(title: :asc) }


  def bitacora(idusr,nusr)
    if saved_changes?
      id=self.id
      modelo = "Ticket"
      p = saved_changes
      k=p.keys
      v=p.values
      @ticket = Ticket.find_by(id: id)
      if saved_change_to_ticket_status_id?
        verbo = "Cambio Estado"
        vactual =  self.ticket_status.name
        if @ticket.ticket_status_id == 2
          TicketSendMailer.send_encuesta_email(@ticket).deliver_now
          TicketSendMailer.send_alerta_crea_email(@ticket).deliver_now
        end
      end
      if saved_change_to_assigned_user_id?
        verbo = "Cambio Asignacion"
        vactual =  self.assigned_user.name
        TicketSendMailer.send_alerta_email(@ticket).deliver_now
      end
      if saved_change_to_ticket_priority_id?
        verbo = "Cambio Prioridad"
        vactual =  self.ticket_priority.name
      end
      if saved_change_to_ticket_reason_id?
        verbo = "Cambio Motivos Cierre"
        vactual =  self.ticket_reason.name
      end
      TicketBitacora.create(modelo_id: id,modelo: modelo, campo: k[0], valor: v[0],valor_actual: vactual,verbo: verbo, user: nusr )

      mensaje= "<div><em>#{verbo} al ticket a #{vactual}</em></div>"
      TicketThread.create(body: mensaje, thread_type:2, ticket_id: id, creator_type: "User", creator_id: idusr)
    end
  end

  def self.search_tickets(params)
    fields = 'tickets.id, tickets.uuid, tickets.title, tickets.updated_at, tickets.ticket_priority_id, tickets.assigned_user_id, tickets.ticket_status_id,
      tickets.client_id, ticket_priorities.name as priority_name, ticket_priorities.color as priority_color, ticket_priorities.priority'.freeze

    tickets = Ticket.left_joins(:ticket_priority).includes(:client, :assigned_user).order(ticket_status_id: :asc, created_at: :asc,priority: :desc).select(fields)

    ticket_number = params[:ticket_number].to_s.strip.to_i
    ticket_title = params[:ticket_title].to_s.strip
    client_id = params[:client_id].to_s.strip.to_i
    ticket_priority_id = params[:ticket_priority_id].to_s.strip.to_i
    assigned_user_id = params[:assigned_user_id].to_s.strip.to_i
    ticket_status_id = params[:ticket_status_id].to_s.strip.to_i
    departament_id = params[:departament_id].to_s.strip.to_i

     tickets = tickets.where(id: ticket_number) if ticket_number != 0
    tickets = tickets.where('title LIKE ?', "%#{ticket_title}%") if !ticket_title.blank?
    tickets = tickets.where(client_id: client_id) if client_id != 0
    tickets = tickets.where(ticket_priority_id: ticket_priority_id) if ticket_priority_id != 0
    tickets = tickets.where(assigned_user_id: assigned_user_id )  if assigned_user_id != 0
    tickets = tickets.where(ticket_status_id: ticket_status_id) if ticket_status_id != 0
    tickets = tickets.where(users: {departament_id: departament_id}).or(tickets.where(assigned_user_id: nil)) if departament_id != 0
    
    tickets
  end

  def client_attributes=(client_attributes)
    return if self.client_source == 'select'

    c = Client.find_or_initialize_by(email: client_attributes[:email])
    c.name = client_attributes[:name]
    c.phone = client_attributes[:phone] unless client_attributes[:phone].blank?
    c.save
    self.client = c
  end

  def ticket_threads_attributes=(ticket_threads_attributes)
    ticket_threads_attributes.values.each do |ticket_thread_attribute|
      attachments = ticket_thread_attribute[:attachments]
      ticket_thread_attribute = ticket_thread_attribute.slice(:body, :thread_type).merge(creator: self.creator)
      ticket_thread = TicketThread.new(ticket_thread_attribute)
      ticket_thread.save_attachments_after_commit(attachments)
      self.ticket_threads << ticket_thread
    end
  end
end
