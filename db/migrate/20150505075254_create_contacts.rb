class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :name, limit: 100, null: false
      t.string :number, limit: 12, null: false

      t.timestamps null: false
    end
  end
end
