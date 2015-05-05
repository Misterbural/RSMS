class CreateReceiveds < ActiveRecord::Migration
  def change
    create_table :receiveds do |t|
      t.string :send_by, limit: 12, null: false
      t.string :content, limit: 1000, null: false
      t.boolean :is_command

      t.timestamps null: false
    end
  end
end
