class CreateScheduleds < ActiveRecord::Migration
  def change
    create_table :scheduleds do |t|
      t.string :content, limit: 1000
      t.boolean :progress
      t.datetime :send_at

      t.timestamps null: false
    end
  end
end
