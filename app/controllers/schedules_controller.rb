class SchedulesController < ApplicationController
  load_and_authorize_resource

  before_action :set_schedule, only: %i[ show edit update destroy ]

  # GET /schedules or /schedules.json
  def index
    @schedules = Schedule.all
  end

  # GET /schedules/1 or /schedules/1.json
  def show; end

  # GET /schedules/new
  def new
    @schedule = Schedule.new
  end

  # GET /schedules/1/edit
  def edit; end

  # POST /schedules or /schedules.json
  def create
    @schedule = Schedule.new(schedule_params)

    respond_to do |format|
      if @schedule.save
        format.html { redirect_to schedule_url(@schedule), notice: "Schedule was successfully created." }
        format.json { render :show, status: :created, location: @schedule }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @schedule.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # PATCH/PUT /schedules/1 or /schedules/1.json
  def update
    respond_to do |format|
      if @schedule.update(schedule_params)
        format.html { redirect_to schedule_url(@schedule), notice: "Schedule was successfully updated." }
        format.json { render :show, status: :ok, location: @schedule }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @schedule.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /schedules/1 or /schedules/1.json
  def destroy
    @branch_office = Sucursal.where(schedule_id: @schedule.id)
    if(@branch_office.empty?)
      @schedule.destroy
      respond_to do |format|
        format.html { redirect_to schedules_url, notice: "Schedule was successfully destroyed." }
        format.json { head :no_content }
      end
    else
      @schedule.errors.add(:schedule," no se puede eliminar porque esta asociado a una sucursal")
      respond_to do |format|
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @schedule.errors, status: :unprocessable_entity }
      end
    end

  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_schedule
      @schedule = Schedule.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def schedule_params
      params.require(:schedule).permit(:name,:lunes_inicio, :lunes_fin, :martes_inicio, :martes_fin, :miercoles_inicio, :miercoles_fin, :jueves_inicio, :jueves_fin, :viernes_inicio, :viernes_fin,:sabado_inicio, :sabado_fin, :domingo_inicio, :domingo_fin)
    end
end