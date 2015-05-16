class CreateContactsGroups < ActiveRecord::Migration
  def change
    create_table :contacts_groups do |t|
      t.belongs_to :group, index:true
      t.belongs_to :contact, index:true
    end
  end
end
