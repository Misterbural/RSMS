class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /groups
  # GET /groups.json
  def index
    @groups = Group.all
  end

  # GET /groups/1
  # GET /groups/1.json
  def show
    usersId = ContactsGroup.where(['group_id = :group_id', { group_id: params[:id] }])
    @users = []
    usersId.each do |id|
      @users << Contact.find_by_id(id.contact_id)
    end
  end

  # GET /groups/new
  def new
    @group = Group.new
    @contacts = Contact.all
    @usersInGroup = []
  end

  # GET /groups/1/edit
  def edit
    @contacts = Contact.all
    usersId = ContactsGroup.where(['group_id = :group_id', { group_id: params[:id] }])
    @usersInGroup = []
    usersId.each do |id|
      @usersInGroup << Contact.find_by_id(id.contact_id)
    end
  end

  # POST /groups
  # POST /groups.json
  def create
    @group = Group.new(group_params)
    users = params[:contacts]
    respond_to do |format|
      if @group.save
        if users
          users.each do |user|
            if !Contact.find_by_id(user).nil?
              ContactsGroup.create(group_id: @group.id, contact_id: user)
            end
          end
        end
        format.html { redirect_to @group, notice: 'Group was successfully created.' }
        format.json { render :show, status: :created, location: @group }
      else
        format.html { render :new }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /groups/1
  # PATCH/PUT /groups/1.json
  def update    
    users = params[:contacts]
    respond_to do |format|
      if @group.update(group_params)
        ContactsGroup.destroy_all(group_id: params[:id])
        if users
          users.each do |user|
            if !Contact.find_by_id(user).nil?
              ContactsGroup.create(group_id: @group.id, contact_id: user)
            end
          end
        end
        format.html { redirect_to @group, notice: 'Group was successfully updated.' }
        format.json { render :show, status: :ok, location: @group }
      else
        format.html { render :edit }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.json
  def destroy
    @group.destroy
    respond_to do |format|
      format.html { redirect_to groups_url, notice: 'Group was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Group.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def group_params
      params.require(:group).permit(:name)
    end
end
