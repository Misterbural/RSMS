class CreateCommands < ActiveRecord::Migration
  def change
    create_table :commands do |t|
      t.string :name, limit: 25, null:false
      t.string :script, limit: 100, null:false
      t.boolean :admin

      t.timestamps null: false
    end
    add_index :commands, :name, unique: true
  end
end
