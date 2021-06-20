class TicketSendMailer < ApplicationMailer

    default :from => 'notificaciones@geosatelital.com'

    # send a signup email to the user, pass in the user object that   contains the user's email address
    #def send_signup_email(ticket)
    def send_signup_email(ticket)
      @ticket = ticket

      make_bootstrap_mail(
        :to => @ticket.client&.email,
        :subject => @ticket.title
        )
    end

    def send_encuesta_email(ticket)
      @ticket = ticket

      make_bootstrap_mail(
        :to => @ticket.client&.email,
        :subject => @ticket.title
        )
    end

    def send_alerta_email(ticket)
      @ticket = ticket

      make_bootstrap_mail(
        :to => @ticket.assigned_user&.email,
        :subject => "#{@ticket.fechaticket}/#{@ticket.title}/[ticket] #{@ticket.id}"
        )
    end
    
    def send_alerta_crea_email(ticket)
      @ticket = ticket

      make_bootstrap_mail(
        :to => @ticket.creator&.email,
        :subject => "[ticket] #{@ticket.id} - #{@ticket.title}"
        )
    end
end
