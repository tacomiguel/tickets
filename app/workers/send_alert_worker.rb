class SendAlertWorker
  include Sidekiq::Worker

  def perform(*args)
    # Do something
    ticket= Ticket.where("ticket_status_id = ?", 1)
    fec_now = Time.current
    ticket.each  do |t|
      fec_ini = t.created_at
      seconds_dif = (fec_now - fec_ini).to_i.abs
      hours = seconds_dif / 3600
      hora = t.ticket_priority.AlertHours
      #puts "fecha dif: #{hours} --- #{hora} "
      if  hours > hora
        @ticket=t
        #puts "el email es: #{ @ticket.assigned_user&.email}"
        TicketSendMailer.send_alerta_email(@ticket).deliver_now

      end
    end

  end
end
