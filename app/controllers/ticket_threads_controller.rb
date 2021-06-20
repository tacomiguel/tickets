class TicketThreadsController < ApplicationController
  before_action :set_ticket

  # GET /ticket_threads or /ticket_threads.json
  def index
    @ticket_threads = @ticket.ticket_threads.includes(:creator).order(created_at: :desc)
   
    # @pagy, @ticket_threads = pagy(@ticket_threads)
  end
 
  # POST /ticket_threads or /ticket_threads.json
  def create
    @ticket_thread = @ticket.ticket_threads.new(ticket_thread_params.merge(creator: current_user))
    #vsendemail=params[:ticket_thread][:send_email]
    vsendemail=params[:ticket_thread][:thread_type]
 
      respond_to do |format|
        if @ticket_thread.save
          save_status_to_ticket
          save_attachments_to_ticket_thread
          if vsendemail == "public_thread"
            TicketSendMailer.send_signup_email(@ticket).deliver_now
          end
          format.html { redirect_to ticket_path(@ticket), notice: "Ticket thread was successfully created." }
          format.json { render :show, status: :created, location: @ticket_thread }
        else
          format.html { render 'tickets/show', status: :unprocessable_entity }
          format.json { render json: @ticket_thread.errors, status: :unprocessable_entity }
        end
      end
    # end 

    
  end

  private

  def set_ticket
    @ticket = Ticket.find(params[:ticket_id])
  end

  def ticket_thread_params
    params.require(:ticket_thread).permit(:body, :thread_type)
  end

  def save_attachments_to_ticket_thread
    attachments = params[:ticket_thread][:attachments]
    @ticket_thread.attachments.attach(attachments) unless attachments.blank?
  end

  def save_status_to_ticket
    ticket_status_id = params[:ticket_thread][:ticket_status_id].to_i
    if ticket_status_id != 0 && ticket_status_id != @ticket.ticket_status_id
      @ticket.update(ticket_status_id: ticket_status_id)
    end
  end
end
