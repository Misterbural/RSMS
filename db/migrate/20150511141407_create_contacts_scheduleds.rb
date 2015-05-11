class CreateContactsScheduleds < ActiveRecord::Migration
  def change
    create_table :contacts_scheduleds do |t|
      t.integer :scheduled_id
      t.integer :contact_id

      t.timestamps null: false
    end
  end
end
