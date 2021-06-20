class TicketStatusesController < ApplicationController
  before_action :set_ticket_status, only: %i[ show edit update destroy ]

  # GET /ticket_statuses or /ticket_statuses.json
  def index
    @search = params[:search].to_s.strip
    @ticket_statuses = TicketStatus.order(:sort).active
    @ticket_statuses = @ticket_statuses.where('name LIKE ?', "%#{@search}%") unless @search.blank?
  end

  # GET /ticket_statuses/1 or /ticket_statuses/1.json
  def show
  end

  # GET /ticket_statuses/new
  def new
    @ticket_status = TicketStatus.new
    respond_to do |f|
      f.js
    end
  end

  # GET /ticket_statuses/1/edit
  def edit
  end

  # POST /ticket_statuses or /ticket_statuses.json
  def create
    @ticket_status = TicketStatus.new(ticket_status_params)

    respond_to do |format|
      if @ticket_status.save
        #format.html { redirect_to @ticket_status, notice: "Ticket status was successfully created." }
        format.html { redirect_to ticket_statuses_url, notice: "Ticket status was successfully created." }
        format.json { render :show, status: :created, location: @ticket_status }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @ticket_status.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ticket_statuses/1 or /ticket_statuses/1.json
  def update
    respond_to do |format|
      if @ticket_status.update(ticket_status_params)
        remove_default_status_of_the_others_ticket_status
        format.html { redirect_to @ticket_status, notice: "Ticket status was successfully updated." }
        format.json { render :show, status: :ok, location: @ticket_status }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @ticket_status.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ticket_statuses/1 or /ticket_statuses/1.json
  def destroy
    if @ticket_status.system_status?
      respond_to do |format|
        format.html { redirect_to ticket_statuses_url, alert: 'No se puede eliminar un estado de sistema.' }
        format.json { render json: { message: 'No se puede eliminar un estado de sistema.' }, status: :bad_request }
      end
      return
    end

    @ticket_status.soft_delete
    respond_to do |format|
      format.html { redirect_to ticket_statuses_url, notice: "Ticket status was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_ticket_status
    @ticket_status = TicketStatus.find(params[:id])
  end

  def ticket_status_params
    #return params.require(:ticket_status).permit(:default) if @ticket_status.system_status?
    params.require(:ticket_status).permit(:name, :sort, :status, :default)
  end

  def remove_default_status_of_the_others_ticket_status
    if ticket_status_params[:default].to_i == 1
      TicketStatus.where(default: 1).where.not(id: @ticket_status.id).update_all(default: 0)
    end
  end
end
