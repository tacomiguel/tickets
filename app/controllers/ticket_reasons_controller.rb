class TicketReasonsController < ApplicationController
  before_action :set_ticket_reason, only: %i[ show edit update destroy ]

  # GET /ticket_reasons or /ticket_reasons.json
  def index
    @search = params[:search].to_s.strip
    @ticket_reasons = TicketReason.order(:sort).active
    @ticket_reasons = @ticket_reasons.where('name LIKE ?', "%#{@search}%") unless @search.blank?
  end

  # GET /ticket_reasons/1 or /ticket_reasons/1.json
  def show
  end

  # GET /ticket_reasons/new
  def new
    @ticket_reason = TicketReason.new
  end

  # GET /ticket_reasons/1/edit
  def edit
  end

  # POST /ticket_reasons or /ticket_reasons.json
  def create
    @ticket_reason = TicketReason.new(ticket_reason_params)

    respond_to do |format|
      if @ticket_reason.save
        format.html { redirect_to @ticket_reason, notice: "Ticket reason was successfully created." }
        format.json { render :show, reason: :created, location: @ticket_reason }
      else
        format.html { render :new, reason: :unprocessable_entity }
        format.json { render json: @ticket_reason.errors, reason: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ticket_reasons/1 or /ticket_reasons/1.json
  def update
    respond_to do |format|
      if @ticket_reason.update(ticket_reason_params)
        remove_default_reason_of_the_others_ticket_reason
        format.html { redirect_to @ticket_reason, notice: "Ticket reason was successfully updated." }
        format.json { render :show, reason: :ok, location: @ticket_reason }
      else
        format.html { render :edit, reason: :unprocessable_entity }
        format.json { render json: @ticket_reason.errors, reason: :unprocessable_entity }
      end
    end
  end

  # DELETE /ticket_reasons/1 or /ticket_reasons/1.json
  def destroy
    if @ticket_reason.system_reason?
      respond_to do |format|
        format.html { redirect_to ticket_reasons_url, alert: 'No se puede eliminar un estado de sistema.' }
        format.json { render json: { message: 'No se puede eliminar un estado de sistema.' }, reason: :bad_request }
      end
      return
    end

    @ticket_reason.soft_delete
    respond_to do |format|
      format.html { redirect_to ticket_reasons_url, notice: "Ticket reason was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_ticket_reason
    @ticket_reason = TicketReason.find(params[:id])
  end

  def ticket_reason_params
    #return params.require(:ticket_reason).permit(:default) if @ticket_reason.system_reason?
    params.require(:ticket_reason).permit(:name, :sort, :status, :default)
  end

  def remove_default_reason_of_the_others_ticket_reason
    if ticket_reason_params[:default].to_i == 1
      TicketReason.where(default: 1).where.not(id: @ticket_reason.id).update_all(default: 0)
    end
  end
end
