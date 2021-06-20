class TicketSourcesController < ApplicationController
  before_action :set_ticket_source, only: %i[ show edit update destroy ]

  # GET /ticket_sources or /ticket_sources.json
  def index
    @ticket_sources = TicketSource.all
  end

  # GET /ticket_sources/1 or /ticket_sources/1.json
  def show
  end

  # GET /ticket_sources/new
  def new
    @ticket_source = TicketSource.new
  end

  # GET /ticket_sources/1/edit
  def edit
  end

  # POST /ticket_sources or /ticket_sources.json
  def create
    @ticket_source = TicketSource.new(ticket_source_params)

    respond_to do |format|
      if @ticket_source.save
        format.html { redirect_to @ticket_source, notice: "Ticket source was successfully created." }
        format.json { render :show, status: :created, location: @ticket_source }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @ticket_source.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ticket_sources/1 or /ticket_sources/1.json
  def update
    respond_to do |format|
      if @ticket_source.update(ticket_source_params)
        format.html { redirect_to @ticket_source, notice: "Ticket source was successfully updated." }
        format.json { render :show, status: :ok, location: @ticket_source }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @ticket_source.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ticket_sources/1 or /ticket_sources/1.json
  def destroy
    @ticket_source.destroy
    respond_to do |format|
      format.html { redirect_to ticket_sources_url, notice: "Ticket source was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ticket_source
      @ticket_source = TicketSource.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def ticket_source_params
      params.require(:ticket_source).permit(:name)
    end
end
