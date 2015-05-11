class ScheduledsController < ApplicationController
  before_action :set_scheduled, only: [:show, :edit, :update, :destroy]

  # GET /scheduleds
  # GET /scheduleds.json
  def index
    @scheduleds = Scheduled.all
  end

  # GET /scheduleds/1
  # GET /scheduleds/1.json
  def show
  end

  # GET /scheduleds/new
  def new
    @scheduled = Scheduled.new
  end

  # GET /scheduleds/1/edit
  def edit
  end

  # POST /scheduleds
  # POST /scheduleds.json
  def create
    @scheduled = Scheduled.new(scheduled_params)

    respond_to do |format|
      if @scheduled.save
        format.html { redirect_to @scheduled, notice: 'Scheduled was successfully created.' }
        format.json { render :show, status: :created, location: @scheduled }
      else
        format.html { render :new }
        format.json { render json: @scheduled.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /scheduleds/1
  # PATCH/PUT /scheduleds/1.json
  def update
    respond_to do |format|
      if @scheduled.update(scheduled_params)
        format.html { redirect_to @scheduled, notice: 'Scheduled was successfully updated.' }
        format.json { render :show, status: :ok, location: @scheduled }
      else
        format.html { render :edit }
        format.json { render json: @scheduled.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /scheduleds/1
  # DELETE /scheduleds/1.json
  def destroy
    @scheduled.destroy
    respond_to do |format|
      format.html { redirect_to scheduleds_url, notice: 'Scheduled was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_scheduled
      @scheduled = Scheduled.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def scheduled_params
      params.require(:scheduled).permit(:content, :prgress)
    end
end
