class CreateCommands < ActiveRecord::Migration
  def change
    create_table :commands do |t|
      t.string :name, limit: 25
      t.string :script, limit: 100
      t.boolean :admin

      t.timestamps null: false
    end
    add_index :commands, :name, unique: true
  end
end
