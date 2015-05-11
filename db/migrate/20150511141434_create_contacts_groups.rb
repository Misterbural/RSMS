class CreateContactsGroups < ActiveRecord::Migration
  def change
    create_table :contacts_groups do |t|
      t.integer :group_id
      t.integer :contact_id

      t.timestamps null: false
    end
  end
end
