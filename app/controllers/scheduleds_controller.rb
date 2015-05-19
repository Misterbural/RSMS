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
    @contacts = Contact.all
    @groups = Group.all

    @contactsInGroup = []
    @groupsInGroup = []
  end

  # GET /scheduleds/1/edit
  def edit
    @contacts = Contact.all
    @groups = Group.all

    contactsId = ContactsScheduled.where(['scheduled_id = :scheduled_id', { scheduled_id: params[:id] }])
    @contactsInGroup = []
    contactsId.each do |id|
      @contactsInGroup << Contact.find_by_id(id.contact_id)
    end

    groupsId = GroupsScheduled.where(['scheduled_id = :scheduled_id', { scheduled_id: params[:id] }])
    @groupsInGroup = []
    groupsId.each do |id|
      @groupsInGroup << Group.find_by_id(id.group_id)
    end
  end

  # POST /scheduleds
  # POST /scheduleds.json
  def create
    @scheduled = Scheduled.new(scheduled_params)

    if params[:contacts]
      dest_contacts = params[:contacts]
    end

    if params[:groups]
      dest_groups = params[:groups]
    end

    respond_to do |format|
      if @scheduled.save
        
        if dest_contacts
          dest_contacts.each do |dest_contact|
            if !Contact.find_by_id(dest_contact).nil?
             ContactsScheduled.create(scheduled_id: @scheduled.id, contact_id: dest_contact)
            end
          end
        end

        if dest_groups
          dest_groups.each do |dest_group|
            if !Group.find_by_id(dest_group).nil?
             GroupsScheduled.create(scheduled_id: @scheduled.id, group_id: dest_group)
            end
          end
        end
            
         
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

    if params[:contacts]
      dest_contacts = params[:contacts]
    end

    if params[:groups]
      dest_groups = params[:groups]
    end
    respond_to do |format|
      if @scheduled.update(scheduled_params)

        ContactsScheduled.destroy_all(scheduled_id: params[:id])
        if dest_contacts
          dest_contacts.each do |dest_contact|
            if !Contact.find_by_id(dest_contact).nil?
              ContactsScheduled.create(scheduled_id: @scheduled.id, contact_id: dest_contact)
            end
          end
        end

        GroupsScheduled.destroy_all(scheduled_id: params[:id])
        if dest_groups
          dest_groups.each do |dest_group|
            if !Group.find_by_id(dest_group).nil?
              GroupsScheduled.create(scheduled_id: @scheduled.id, group_id: dest_group)
            end
          end
        end

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

      params.require(:scheduled).permit(:content, :progress, :send_at)

    end
end
