class ReceivedsController < ApplicationController
  before_action :set_received, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /receiveds
  # GET /receiveds.json
  def index
    @receiveds = Received.all
  end

  # GET /receiveds/1
  # GET /receiveds/1.json
  def show
  end

  # GET /receiveds/new
  def new
    @received = Received.new
  end

  # GET /receiveds/1/edit
  def edit
  end

  # POST /receiveds
  # POST /receiveds.json
  def create
    @received = Received.new(received_params)

    respond_to do |format|
      if @received.save
        format.html { redirect_to @received, notice: 'Received was successfully created.' }
        format.json { render :show, status: :created, location: @received }
      else
        format.html { render :new }
        format.json { render json: @received.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /receiveds/1
  # PATCH/PUT /receiveds/1.json
  def update
    respond_to do |format|
      if @received.update(received_params)
        format.html { redirect_to @received, notice: 'Received was successfully updated.' }
        format.json { render :show, status: :ok, location: @received }
      else
        format.html { render :edit }
        format.json { render json: @received.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /receiveds/1
  # DELETE /receiveds/1.json
  def destroy
    @received.destroy
    respond_to do |format|
      format.html { redirect_to receiveds_url, notice: 'Received was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_received
      @received = Received.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def received_params
      params.require(:received).permit(:send_by, :content, :is_command)
    end
end
