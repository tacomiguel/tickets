class TicketPrioritiesController < ApplicationController
  before_action :set_ticket_priority, only: %i[ show edit update destroy ]

  # GET /ticket_priorities or /ticket_priorities.json
  def index
    @search = params[:search].to_s.strip
    @ticket_priorities = TicketPriority.active.order(priority: :asc)
    @ticket_priorities = @ticket_priorities.where('name LIKE ?', "%#{@search}%") unless @search.blank?
    @pagy, @ticket_priorities = pagy(@ticket_priorities)
  end

  # GET /ticket_priorities/1 or /ticket_priorities/1.json
  def show
  end

  # GET /ticket_priorities/new
  def new
    @ticket_priority = TicketPriority.new
  end

  # GET /ticket_priorities/1/edit
  def edit
  end

  # POST /ticket_priorities or /ticket_priorities.json
  def create
    @ticket_priority = TicketPriority.new(ticket_priority_params)

    respond_to do |format|
      if @ticket_priority.save
        format.html { redirect_to @ticket_priority, notice: "Ticket priority was successfully created." }
        format.json { render :show, status: :created, location: @ticket_priority }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @ticket_priority.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ticket_priorities/1 or /ticket_priorities/1.json
  def update
    respond_to do |format|
      if @ticket_priority.update(ticket_priority_params)
        format.html { redirect_to @ticket_priority, notice: "Ticket priority was successfully updated." }
        format.json { render :show, status: :ok, location: @ticket_priority }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @ticket_priority.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ticket_priorities/1 or /ticket_priorities/1.json
  def destroy
    @ticket_priority.soft_delete
    respond_to do |format|
      format.html { redirect_to ticket_priorities_url, notice: "Ticket priority was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
  def set_ticket_priority
    @ticket_priority = TicketPriority.find(params[:id])
  end

  def ticket_priority_params
    params.require(:ticket_priority).permit(:name, :color, :priority, :status, :alerthours)
  end
end
