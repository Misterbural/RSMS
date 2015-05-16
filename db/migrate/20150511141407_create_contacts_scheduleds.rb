class CreateContactsScheduleds < ActiveRecord::Migration
  def change
    create_table :contacts_scheduleds do |t|
      t.belongs_to :scheduled, index: true
      t.belongs_to :contact, index: true
    end
  end
end
