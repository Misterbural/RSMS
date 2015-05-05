class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :name, limit: 100
      t.string :number, limit: 12

      t.timestamps null: false
    end
  end
end
