class SendedsController < ApplicationController
  before_action :set_sended, only: [:show, :edit, :update, :destroy]

  # GET /sendeds
  # GET /sendeds.json
  def index
    @sendeds = Sended.all
  end

  # GET /sendeds/1
  # GET /sendeds/1.json
  def show
  end

  # GET /sendeds/new
  def new
    @sended = Sended.new
  end

  # GET /sendeds/1/edit
  def edit
  end

  # POST /sendeds
  # POST /sendeds.json
  def create
    @sended = Sended.new(sended_params)

    respond_to do |format|
      if @sended.save
        format.html { redirect_to @sended, notice: 'Sended was successfully created.' }
        format.json { render :show, status: :created, location: @sended }
      else
        format.html { render :new }
        format.json { render json: @sended.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sendeds/1
  # PATCH/PUT /sendeds/1.json
  def update
    respond_to do |format|
      if @sended.update(sended_params)
        format.html { redirect_to @sended, notice: 'Sended was successfully updated.' }
        format.json { render :show, status: :ok, location: @sended }
      else
        format.html { render :edit }
        format.json { render json: @sended.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sendeds/1
  # DELETE /sendeds/1.json
  def destroy
    @sended.destroy
    respond_to do |format|
      format.html { redirect_to sendeds_url, notice: 'Sended was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sended
      @sended = Sended.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sended_params
      params.require(:sended).permit(:target, :content)
    end
end
