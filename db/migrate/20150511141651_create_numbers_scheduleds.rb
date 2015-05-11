class CreateNumbersScheduleds < ActiveRecord::Migration
  def change
    create_table :numbers_scheduleds do |t|
      t.integer :scheduled_id
      t.string :number, limit: 12

      t.timestamps null: false
    end
  end
end
