class CreateScheduleds < ActiveRecord::Migration
  def change
    create_table :scheduleds do |t|
      t.string :content, limit: 1000, null: false
      t.boolean :prgress, null: false

      t.timestamps null: false
    end
  end
end
