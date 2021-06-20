class DepartamentsController < ApplicationController
  before_action :set_departament, only: %i[ show edit update destroy ]

  # GET /departaments or /departaments.json
  def index
    @search = params[:search].to_s.strip
    @departaments = Departament.active
    @departaments = @departaments.where('name LIKE ?', "%#{@search}%") unless @search.blank?
    @pagy, @departaments = pagy(@departaments)
  end

  # GET /departaments/1 or /departaments/1.json
  def show
  end

  # GET /departaments/new
  def new
    @departament = Departament.new
  end

  # GET /departaments/1/edit
  def edit
  end

  # POST /departaments or /departaments.json
  def create
    @departament = Departament.new(departament_params)

    respond_to do |format|
      if @departament.save
        format.html { redirect_to @departament, notice: "Departament was successfully created." }
        format.json { render :show, status: :created, location: @departament }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @departament.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /departaments/1 or /departaments/1.json
  def update
    respond_to do |format|
      if @departament.update(departament_params)
        format.html { redirect_to @departament, notice: "Departament was successfully updated." }
        format.json { render :show, status: :ok, location: @departament }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @departament.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /departaments/1 or /departaments/1.json
  def destroy
    @departament.soft_delete
    respond_to do |format|
      format.html { redirect_to departaments_url, notice: "Departament was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_departament
    @departament = Departament.active.find(params[:id])
  end

  def departament_params
    params.require(:departament).permit(:name, :status)
  end
end
